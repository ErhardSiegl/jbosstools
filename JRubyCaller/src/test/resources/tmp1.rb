def start()
puts "Hello " + __FILE__
puts "PROGRAM_NAME  " + $PROGRAM_NAME 
end

if $PROGRAM_NAME == __FILE__
	start()
end

