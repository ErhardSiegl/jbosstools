puts "Hello - This is test1.rb"

puts RUBY_PLATFORM
if RUBY_PLATFORM =~ /linux/ then
  puts "Linux"
  #Linux Stuff
elsif RUBY_PLATFORM =~ /mswin32/ then
  puts "Windows"
  #Windows Stuff
end

def getPid()
  ppid=5324
  pid=`ps --ppid #{ppid} | perl -wne '{/([0-9]+)/ && print $1}'`
  puts "PID: " + pid
end
  
getPid


#get_pid() {
#    if [ -f $pidfile ]; then
#        ps --ppid `cat $pidfile` | perl -wne '{/([0-9]+)/ && print $1}'
#    fi
#}

