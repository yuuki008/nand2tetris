require '../jack_analyzer'

print "Enter the path of the file or directory: "
path = gets.chomp
JackAnalyzer.new(path).execute