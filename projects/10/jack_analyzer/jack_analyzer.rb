require_relative './jack_tokenizer'

class JackAnalyzer
  def initialize
    # @path = get.chomp
    @path = '../Square'
  end

  def execute
    jack_files.each do |file_path|
      tokenizer = JackTokenizer.new(file_path).execute
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

JackAnalyzer.new.execute