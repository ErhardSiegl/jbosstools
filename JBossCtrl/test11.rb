puts "Hello - This is test1.rb"

 require 'sys/proctable'
   include Sys

   # Everything
   ProcTable.ps{ |p|
      puts "#{p.pid.to_s} #{p.ppid} #{p.comm}"
#      puts p.comm
   }
   puts ProcTable.fields()
   
