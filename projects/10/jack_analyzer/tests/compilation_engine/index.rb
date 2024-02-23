require_relative '../../compilation_engine'
require_relative "../../jack_tokenizer"
require 'minitest/autorun'

class CompilationEngineTest < Minitest::Test
  def test_compile_class
    tokenizer = JackTokenizer.new(File.join(__dir__, 'test.jack'))
    CompilationEngine.new(tokenizer)

    expected = File.read('tests/compilation_engine/test.xml.expected').gsub(/\s+/, "").chomp
    actual = File.read('tests/compilation_engine/test.xml').gsub(/\s+/, "").chomp

    assert_equal expected, actual
  end 
end