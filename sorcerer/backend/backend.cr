require "../ast/program"

module Backend
  abstract class Backend
    # returns the exit code of the program
    abstract def compile(programs : Array(Ast::Program)) : Int32
  end
end

require "./cpp"
