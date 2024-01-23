class Parser
  def initialize(file_path)
    lines = file_readlines(file_path)
    @commands = lines.reject { |line| line.include?("//") || line.strip.empty? }
    @index = 0
  end

  def has_more_commands
    @index < @commands.length
  end

  def advance
    @index += 1
  end

  def command_type
    command = @commands[@index].strip

    case
    when command.include?("push")
      return "C_PUSH"
    when command.include?("pop")
      return "C_POP"
    when command.include?("label")
      return "C_LABEL"
    when command.include?("goto")
      return "C_GOTO"
    when command.include?("if-goto")
      return "C_IF"
    when command.include?("function")
      return "C_FUNCTION"
    when command.include?("call")
      return "C_CALL"
    when command.include?("return")
      return "C_RETURN"
    else
      return "C_ARITHMETIC"
    end
  end

  def arg1
    @commands[@index].strip.split(" ")[1]
  end

  def arg2
    @commands[@index].strip.split(" ")[2]
  end

  private 
  def file_readlines(file_path)
    if File.extname(file_path) != ".vm"
      puts "エラー: 指定されたファイルはVMファイルではありません。プログラムを中断します。"
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