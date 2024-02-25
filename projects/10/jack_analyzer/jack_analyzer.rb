require_relative './jack_tokenizer'
require_relative './compilation_engine'

class JackAnalyzer
  def initialize(path)
    @path = path
  end

  def execute
    jack_files.each do |file_path|
      tokenizer = JackTokenizer.new(file_path)
      CompilationEngine.new(tokenizer)
    end
  end

  private 
  def jack_file?
    @path.end_with?(".jack")
  end

  def jack_files
    return [@path] if @path.end_with?(".jack")

    dir = @path.end_with?("/") ? @path[..-2] : @path
    Dir.glob("#{dir}/*.jack")
  end
end
