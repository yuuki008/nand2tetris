require_relative './parser.rb'
require_relative './code.rb'
require_relative './symbol_table.rb'

class Assembler
  def initialize(file_path)
    @symbol_table = SymbolTable.new
    @file_path = file_path
    @code = Code.new
  end

  def execute 
    first_path
    second_path
    compile

    puts "Hackファイルへの出力が完了しました。"
  end

  private

  def first_path
    parser = Parser.new(@file_path)

    pc = 0
    while parser.has_more_commands
      if parser.command_type === "L_COMMAND"
        @symbol_table.add_entry(parser.symbol, pc)
      else
        pc += 1
      end

      parser.advance
    end
  end

  def second_path
    parser = Parser.new(@file_path)

    next_address = 16
    while parser.has_more_commands
      next parser.advance if parser.command_type != "A_COMMAND" 
      next parser.advance if parser.symbol.match?(/\A\d+\z/)
      next parser.advance if @symbol_table.contains?(parser.symbol)

      @symbol_table.add_entry(parser.symbol, next_address)
      next_address += 1

      parser.advance
    end
  end

  def compile
    output_file_path = @file_path.gsub(/\.asm$/, ".hack")

    output_file = File.open(output_file_path, "w")
    parser = Parser.new(@file_path)

    while parser.has_more_commands    
      case parser.command_type
      when "A_COMMAND"
        address = parser.symbol.match?(/\A\d+\z/) ? parser.symbol.to_i : @symbol_table.get_address(parser.symbol)
        output_file.puts "#{address.to_s(2).rjust(16, '0')}"
      when 'C_COMMAND'
        output_file.puts "111#{@code.comp(parser.comp)}#{@code.dest(parser.dest)}#{@code.jump(parser.jump)}"
      end

      parser.advance
    end
  end
end

print "アセンブリファイルのパスを入力してください:"
file_path = gets.chomp
Assembler.new(file_path).execute