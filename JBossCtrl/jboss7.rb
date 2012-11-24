#!/usr/bin/ruby

require 'rbconfig'
require 'fileutils'

JBOSS_HOME = ENV["JBOSS_HOME"]
DEPLOY_DIR = JBOSS_HOME + "/standalone/deployments"
MODULE_DIR = JBOSS_HOME + "/modules"
LOG_DIR = JBOSS_HOME + "/standalone/log"
OUT_FILE = LOG_DIR + "/out.log"
TIMEOUT=20

JBOSS_OPTS = ENV["JBOSS_OPTS"]
PID_FILE = JBOSS_HOME + "/standalone/pid.lock"

RUBY = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])
SHELL = "/bin/sh"

def printHelp
  puts "Help!"
end

def callRuby(file)
  puts "call Ruby script #{file}"
  success = system(RUBY, file)
  if !success
    raise "Execution of #{file} failed"
  end
  puts "Executed #{file}: #{success}"
end

def callShellScript(file)
  success = system(SHELL, file)
  if !success
    raise "Execution of #{file} failed"
  end
  puts "Executed #{file}: #{success}"
end

def callJBossCli(file)
  jbossCli = ""
  case RbConfig::CONFIG['host_os']
  when /linux/     
    jbossCli="#{JBOSS_HOME}/bin/jboss-cli.sh"
  else
  raise "Unsupported Platform: #{RbConfig::CONFIG['host_os']}"
  end

  success = system(jbossCli, "--connect", "--file=#{file}")
  if !success
    raise "Execution of #{file} failed"
  end
end

def installModule(file)
  success = system('unzip', '-o', '-d', MODULE_DIR, file)
  if !success
    raise "Unzip of #{file} failed"
  end
end

def deploy(file)
  STDERR.puts "Deploy #{file} to #{DEPLOY_DIR}"
  if file.nil?
    raise "Missing argument"
  end
  if !File.exist? file
    raise "File does not exist: #{file}"
  end
  FileUtils.cp(file, DEPLOY_DIR)
end

def configure(file)
  if file.nil?
    raise "Missing argument"
  end
  if !File.exist? file
    raise "File does not exist: #{file}"
  end

  if File.directory? file
    Dir.entries(file).sort.each { |entry|
      next if entry == '.' or entry == '..'
      Dir.chdir file do
        configure entry
      end
    }
  return
  end

  case File.extname file
  when ".rb"
    callRuby file
  when ".sh"
    callShellScript file
  when ".module"
    installModule file
  when ".conf"
    callJBossCli file
  when ".restart"
    stop
    start
  else
  STDERR.puts "INFO: #{file}: Illegal file extension: #{File.extname file}"
  end
end

def getPid()
  if !File.readable? PID_FILE
    puts "No PID_FILE " + PID_FILE
  return 0
  end
  ppid = 0
  File.open(PID_FILE, 'r') {|f| ppid = f.read()  }

  pid=`ps --ppid #{ppid} | perl -wne '{/([0-9]+)/ && print $1}'`
  pid.to_i
end

def printVersion
  puts " RUBY_PLATFORM: #{RUBY_PLATFORM}"
  if defined? JRUBY_VERSION
    puts " JRUBY_VERSION: #{JRUBY_VERSION}"
  end
  if defined? RUBY_VERSION
    puts " RUBY_VERSION: #{RUBY_VERSION}"
  end
  puts " RbConfig::CONFIG['RUBY_INSTALL_NAME']: #{RbConfig::CONFIG['RUBY_INSTALL_NAME']}"
end

def running?
  pid = getPid()
  return pid!=0
end

def started?
  started = false
  File.open(OUT_FILE, 'r') {|f|
    started = f.grep(/JBoss.*started/)
  }
  !started.empty?
end

def waitForStart
  timeout = TIMEOUT
  while !started? && (--timeout > 0)
    print "."
    sleep 1
  end
  if started?
    puts "JBoss started"
  else
    if running?
      puts "JBoss process running, but no started-message in logfile within #{TIMEOUT} seconds!"
    else
      puts "Startup failed"
    end
  end
end

def stopFailed?
  timeout = TIMEOUT
  while running? && (--timeout > 0)
    print "."
    sleep 1
  end
  timeout == 0
end

def start
  puts "Start JBoss: " + RbConfig::CONFIG['host_os']

  if running?
    raise "JBoss is already running. PID: #{getPid}"
  end

  case RbConfig::CONFIG['host_os']
  when /linux/
    File.delete(OUT_FILE) if File.exist? OUT_FILE
    Dir.mkdir(LOG_DIR) if !Dir.exist? LOG_DIR
    
    startCmd="#{JBOSS_HOME}/bin/standalone.sh #{JBOSS_OPTS}"
    puts startCmd
    pid = Process.spawn(startCmd, :out=>OUT_FILE)
    Process.detach pid
    File.open(PID_FILE, 'w') {|f| f.write(pid) }
  else
  raise "Unsupported Platform: #{RbConfig::CONFIG['host_os']}"
  end
  waitForStart
end

def stop
  if !running?
    puts "JBoss is not running!"
  return
  end
  pid = getPid
  Process.kill("TERM", pid)
  if stopFailed?
    puts "JBoss not terminated, killing process"
    Process.kill("KILL'", pid)
    sleep 2
    if running?
      raise "Couldn't stop JBoss!"
    end
  else
    puts "JBoss stopped"
  end
  if running?
    puts "Something is wrong"
  end

end

def status
  pid = getPid
  if !running?
    puts "JBoss stopped"
  else
    if started?
      puts "JBoss started"
    else
      puts "JBoss starting"
    end
    puts "PID: #{pid}"
  end
end

args = nil
if !$args.nil?
args = $args[1,$args.length]

end

if args.nil? || args.empty?
  args = ARGV
end

if args.empty?
  puts "No arguments given!"
  printHelp
  exit 1
end

begin
  case args[0]
  when "configure"
    configure args[1]
  when "deploy"
    deploy args[1]
  when "start"
    start
  when "stop"
    stop
  when "restart"
    stop
    start
  when "status"
    status
  when "version"
    printVersion
  else
  raise "Illegal Argument #{args[0]}!"
  end

rescue
  puts "Error: #{$!}"
  printHelp
  raise
end
