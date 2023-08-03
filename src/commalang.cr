require "option_parser"
require "./util"
require "./parser"

# TODO: Write documentation for `Commalang`
module Commalang
  VERSION = "0.1.0"

  # TODO: Put your code here
  puts "its ,lang baby. hell yeah"
  files = [] of String

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
    parser.unknown_args do |args|
      files = args
    end
  end

  files.each do |file|
    puts "file: #{file}"
    parser = Parser.new Lexer.new Reader.from_file file
    p! parser.parse
  end
end
