module InstallJBoss


JBOSS_HOME = ENV["JBOSS_HOME"]
JBossPackage = ENV["JBossPackage"]

require 'rubygems'
require 'fileutils'
require 'zip/zip'

def InstallJBoss.unzip_file(file, destination)
#  if File.exist?(destination) then
#    FileUtils.rm_rf destination
#  end
  #zip = Zip::ZipFile.new(file)
  #zip.restore_permissions = true
  
  puts "unzip #{file} to #{destination}"
  Zip::ZipFile.open(file) { |zip_file|
  zip_file.restore_permissions = true
   zip_file.each { |f|
     f_path=File.join(destination, f.name)
     FileUtils.mkdir_p(File.dirname(f_path))
     zip_file.extract(f, f_path)
   }
  }
end

def InstallJBoss.unzipJBoss(file, jbossHome)
  tmpInstall = "#{jbossHome}_TmpInstall"
  if File.exist? tmpInstall
    raise "File or directory #{tmpInstall} exists. Remove it manually!"
  end

  unzip_file(file, tmpInstall)
#  success = system('unzip', '-d', tmpInstall, file)
#  if !success
#    raise "Unzip of #{file} to #{tmpInstall} failed!"
#  end

  File.rename Dir.glob("#{tmpInstall}/*")[0], jbossHome
  Dir.delete tmpInstall

end

unzipJBoss(JBossPackage, JBOSS_HOME)

end