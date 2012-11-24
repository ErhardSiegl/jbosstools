
require 'rbconfig'
tHIS_FILE = File.expand_path(__FILE__)
ruby = File.join(Config::CONFIG['bindir'], Config::CONFIG['ruby_install_name'])

$stdout.sync = true
puts "RUBY: " + ruby

if $PROGRAM_NAME == __FILE__

File1 = "tmp1.rb"

output = `#{ruby} #{File1}`
output.split("\n").each do |line|
  puts "#{line}"
end
puts


end
