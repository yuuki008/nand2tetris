require_relative './code.rb'

class Parser
  def initialize(file_path)
    lines = file_readlines(file_path)
    @commands = lines.reject { |line| line.start_with?("//") || line.strip.empty? }
    @index = 0
  end

  def has_more_commands
    @index < @commands.length
  end

  def advance
    @index += 1
  end

  def dest
    @commands[@index].include?("=")  ? @commands[@index].split("=")[0] : ""
  end

  def comp
    command = @commands[@index].include?("=") ? @commands[@index].split("=")[1] : @commands[@index]
    command.split(";")[0].strip
  end

  def jump
    @commands[@index].include?(";") ? @commands[@index].split(";")[1].strip : ""
  end

  def command_type
    if @commands[@index].start_with?("@")
      return "A_COMMAND"
    elsif @commands[@index].include?("=") || @commands[@index].include?(";")
      return "C_COMMAND"
    else
      return "L_COMMAND"
    end
  end

  def symbol
    @commands[@index].gsub(/[@\(\)]/, "")
  end

  private 

  def file_readlines(file_path)
    if File.extname(file_path) != ".asm"
      puts "エラー: 指定されたファイルはアセンブリファイルではありません。プログラムを中断します。"
      exit 1 
    end

    begin
      File.readlines(file_path)
    rescue Errno::ENOENT
      puts "エラー: 指定されたファイルが見つかりませんでした。プログラムを中断します。"
      exit 1 
    rescue => e
      puts "エラーが発生しました: #{e.message}プログラムを中断します。"
      exit 1 
    end
  end
end