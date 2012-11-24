#module CallRbSystem

require 'rbconfig'

RUBY = File.join(Config::CONFIG['bindir'], Config::CONFIG['ruby_install_name'])

$stdout.sync = true
puts "RUBY: " + RUBY

if $PROGRAM_NAME == __FILE__

File1 = "tmp1.rb"
File2 = "tmp2.rb"

success = system(RUBY, File1)
puts "[parent 1] success: #{success}"
success = system(RUBY, File2)
puts "[parent] success: #{success}"

end

#end