require_relative "../../jack_analyzer"
require "minitest/autorun"

class JackAnalyzerTest < Minitest::Test
  def test_array_test
    current_dir = File.expand_path(__dir__)
    dir_path = File.join(current_dir, "../../../ArrayTest")

    JackAnalyzer.new(dir_path).execute

    expected = File.read(File.join(dir_path, "Main.xml.expected")).gsub(/\s+/, "").chomp
    actual = File.read(File.join(dir_path, "Main.xml")).gsub(/\s+/, "").chomp

    assert_equal expected, actual
  end

  def test_expression_less_square_main
    current_dir = File.expand_path(__dir__)
    dir_path = File.join(current_dir, "../../../ExpressionLessSquare")

    JackAnalyzer.new(dir_path).execute

    expected_files = Dir.glob("#{dir_path}/*.xml.expected").reject { |file| file.include?("T.xml") }
    actual_files = Dir.glob("#{dir_path}/*.xml").reject { |file| file.include?("T.xml") }

    expected_files.each_with_index do |file, index|
      expected_file_name = File.basename(file)

      actual_file_name = expected_file_name.gsub(".expected", "")
      actual_file = actual_files.find { |file_path| File.basename(file_path) == actual_file_name }

      expected = File.read(file).gsub(/\s+/, "").chomp
      actual = File.read(actual_file).gsub(/\s+/, "").chomp

      assert_equal expected, actual
    end
  end
end