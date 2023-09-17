require "option_parser"
require "./util"
require "./parser"
require "./backend"

# TODO: Write documentation for `Comma`
module Comma
  VERSION = "0.1.0"

  # TODO: Put your code here
  puts "its ,lang baby. hell yeah"
  files = [] of String
  cpp_destination = Path.new(Dir.tempdir, "comma.cpp").to_s
  cpp_compiler = "clang++"
  output = ""

  OptionParser.parse do |parser|
    parser.banner = ",lang"

    parser.on "-v", "--version", "Show version" do
      puts "version #{VERSION}"
      exit
    end
    parser.on "-h", "--help", "Show help" do
      puts parser
      exit
    end
    parser.on "-o", "--output FILE", "Output to file" do |file|
      output = file
    end
    parser.on "--cc COMPILER", "Use a specific C++ compiler (default: clang++)" do |compiler|
      cpp_compiler = compiler
    end
    parser.on "--cpp FILE", "Output C++ to this file instead of tmp (#{cpp_destination})" do |file|
      cpp_destination = file
    end
    parser.unknown_args do |args|
      files = args
    end
  end

  if files.empty?
    puts "no files specified"
    exit 1
  end

  if output == ""
    puts "output file not specified"
    exit 1
  end

  backend = Backend::Cpp.new(output, cpp_destination, cpp_compiler)

  # todo dependency tree resolving or something
  exit backend.compile files.map { |file|
    puts "file: #{file}"
    parser = Parser.new Lexer.new Reader.from_file file
    program = parser.parse
    debu! program
    program
  }
end
