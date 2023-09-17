class Backend::Cpp < Backend::Backend
  property output : String
  property cpp_destination : String
  property cpp_compiler : String

  def initialize(@output : String, @cpp_destination : String, @cpp_compiler : String)
  end

  def compile(programs : Array(Ast::Program)) : Int32
    File.open(cpp_destination, "w") do |file|
      file << {{ read_file("sorcerer/backend/cpp/,std.cpp") }}
      file << "
      int main() {
      ::comma::premain();
      "
      file << "\n"
      programs.each do |program|
        declare_exports file, program
      end
      programs.each do |program|
        cppify file, program
      end
      file << "return 0;
  }"
    end
    puts "wrote to #{cpp_destination}"
    puts "compiling..."
    puts "$ #{cpp_compiler} #{cpp_destination} -o #{output}"
    process = Process.new cpp_compiler, args: [cpp_destination, "-o", output], output: Process::Redirect::Inherit, error: Process::Redirect::Inherit
    status = process.wait
    puts "Status: #{status}"
    # File.delete tempfile
    if !status.success?
      puts "compilation failed"
      status.exit_code
    else
      puts "compiled :3"
      0
    end
  end

  private def declare_exports(io : IO, program : Ast::Program) : Nil
    program.exports.each { |statement|
      case statement
      when Ast::Statement::FunctionDeclaration
        io << "std::function<"
        cppify io, statement.returns
        io << "("
        statement.parameters.each_with_index do |p, i|
          if i > 0
            io << ", "
          end
          cppify io, p[:type]
        end
        io << ")> "
        cppify io, statement.name
        io << ";\n"
      when Ast::Statement::VariableDeclaration
        cppify io, statement.type
        io << ' '
        cppify io, statement.name
        io << ";\n"
      else
        raise "unreachable"
      end
    }
  end

  private def cppify(io : IO, program : Ast::Program) : Nil
    program.statements.each { |statement|
      cppify io, statement
    }
  end

  private def cppify(io : IO, binop : Ast::Expression::Binop) : Nil
    case binop.operator
    when BinaryOperator::DIFF
      io << "::std::abs("
    when BinaryOperator::TO_THE_POWER_OF
      io << "::std::pow("
    when BinaryOperator::MODULO
      io << "::comma::mod("
    else
    end
    cppify io, binop.first
    io << case binop.operator
    when BinaryOperator::GREATER
      ">"
    when BinaryOperator::LESS
      "<"
    when BinaryOperator::GREATER_EQUALS
      ">="
    when BinaryOperator::LESS_EQUALS
      "<="
    when BinaryOperator::PLUS
      "+"
    when BinaryOperator::MINUS
      "-"
    when BinaryOperator::DIFF
      "-"
    when BinaryOperator::TIMES
      "*"
    when BinaryOperator::DIVIDED_BY
      "/"
    when BinaryOperator::TO_THE_POWER_OF
      ","
    when BinaryOperator::MODULO
      ","
    else
      raise "unreachable"
    end
    cppify io, binop.second

    case binop.operator
    when BinaryOperator::DIFF, BinaryOperator::TO_THE_POWER_OF, BinaryOperator::MODULO
      io << ")"
    else
    end
  end

  private def cppify(io : IO, call : Ast::Expression::Call) : Nil
    cppify io, call.callee
    io << "("
    call.arguments.each_with_index do |arg, i|
      cppify io, arg
      io << ", " if i < call.arguments.size - 1
    end
    io << ")"
  end

  private def cppify(io : IO, block : Ast::Statement::Block) : Nil
    block.statements.each_with_index do |s, i|
      if i > 0
        io << "\n"
      end
      cppify io, s
    end
  end

  private def cppify(io : IO, cast : Ast::Expression::Cast) : Nil
    io << "static_cast<"
    cppify io, cast.type
    io << ">("
    cppify io, cast.casted
    io << ")"
  end

  private def cppify(io : IO, variable : Ast::Expression::Variable) : Nil
    cppify io, variable.name
  end

  private def cppify(io : IO, chance : Ast::Expression::ChanceLiteral) : Nil
    if chance.runtime
      io << "::comma::Chance{"
      io << chance.chance
      io << "}"
    elsif rand < chance.chance
      io << "true"
    else
      io << "false"
    end
  end

  private def cppify(io : IO, char : Ast::Expression::CharLiteral) : Nil
    io << "L'"
    io << char.value.unicode_escape
    io << "'"
  end

  private def cppify(io : IO, float : Ast::Expression::FloatLiteral) : Nil
    io << float.value
  end

  def cppify(io : IO, integer : Ast::Expression::IntegerLiteral) : Nil
    io << integer.value
  end

  def cppify(io : IO, string : Ast::Expression::StringLiteral) : Nil
    commas = 1 + string.value.count ','
    dchars = "," * commas
    io << "::comma::string(LR\""
    io << dchars
    io << "haiii:3("
    io << string.value
    io << ")"
    io << dchars
    io << "haiii:3\")"
  end

  def cppify(io : IO, again : Ast::Statement::Again) : Nil
    io << "goto "
    cppify io, again.start
    io << ';'
  end

  def cppify(io : IO, not_again : Ast::Statement::NotAgain) : Nil
    io << "goto "
    cppify io, not_again.endname
    io << ';'
  end

  def cppify(io : IO, conditional : Ast::Statement::Conditional) : Nil
    cppify io, conditional.label
    io << ':'
    conditional.elifs.each_with_index do |elif, i|
      if i > 0
        io << "else "
      end
      io << "if ("
      cppify io, elif[:condition]
      io << ") { "
      cppify io, elif[:block]
      io << " }"
    end
    else_body = conditional.else_body
    if !else_body.nil?
      io << "else { "
      cppify io, else_body
      io << " }"
    end
    cppify io, conditional.label.reverse
    io << ":;"
  end

  def cppify(io : IO, function : Ast::Statement::FunctionDeclaration) : Nil
    io << "auto " unless function.exported?
    cppify io, function.name
    io << "= [&]("
    function.parameters.each_with_index do |p, i|
      if i > 0
        io << ", "
      end
      cppify io, p[:type]
      io << ' '
      cppify io, p[:name]
    end
    io << ") -> "
    cppify io, function.returns
    io << " {\n"
    cppify io, function.block
    io << '\n'
    last_declared = function.last_declared_variable
    if last_declared.nil?
      # undefined behavior
      io << "puts(\":3\");exit(123);"
    else
      io << "return "
      cppify io, last_declared.name
      io << ';'
    end
    io << "\n};"
  end

  def cppify(io : IO, variable : Ast::Statement::VariableDeclaration) : Nil
    unless variable.exported?
      cppify io, variable.type
      io << ' '
    end
    cppify io, variable.name
    io << " = "
    cppify io, variable.value
    io << ';'
  end

  def cppify(io : IO, assignment : Ast::Statement::Assignment) : Nil
    cppify io, assignment.name
    io << " = "
    cppify io, assignment.value
    io << ';'
  end

  def cppify(io : IO, expression : Ast::Statement::Expression) : Nil
    cppify io, expression.expression
    io << ';'
  end

  def cppify(io : IO, identifier : Ast::Identifier) : Nil
    io << "comma_"
    io << identifier.string
    io << "_"
  end

  def cppify(io : IO, type : Type) : Nil
    io << type.cppify
  end
end
