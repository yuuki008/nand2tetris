require_relative './jack_tokenizer'

class JackAnalyzer
  def initialize
    # @path = get.chomp
    @path = '../Square'
  end

  def execute
    if jack_file?
      tokenizer = JackTokenizer.new(@path).execute
    else
      jack_files.each do |file_path|
        tokenizer = JackTokenizer.new(file_path).execute
      end
    end
  end

  private 
  def jack_file?
    @path.end_with?(".jack")
  end

  def jack_files
    dir = @path.end_with?("/") ? @path[..-2] : @path
    Dir.glob("#{dir}/*.jack")
  end
end

JackAnalyzer.new.execute