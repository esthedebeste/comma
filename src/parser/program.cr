require "./statement"

class Program
  property statements : Array(Statement)

  def initialize(@statements : Array(Statement))
  end

  def cppify
    "#{{{ read_file("src/cppstd/,std.cpp") }}}

int main() {
  #{@statements.join("\n")}
  return 0;
}"
  end
end
