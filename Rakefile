# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

# The list of files that should be ignored by git.
IgnoredFiles = [ "config/database.yml", 
                 "log/*.log",
                 "log/*.pid",
                 "db/*.sqlite3"
                ]
                
desc "Set up the local copy of sherlocksampling for development."
task :setup => :add_ignored_files_to_git

desc "Tell git to ignore files that we really shouldn't be tracking."
task :add_ignored_files_to_git do
  
  already_ignored = []
  
  # See what files are already ignored.
  File.open('.git/info/exclude', 'r') do |f|
    # The chomp removes the whitespace and newlines that could screw up
    # the reject! statement below. 
    already_ignored = f.readlines.map{|l| l.chomp }
  end
  
  # Add all the files that need to be ignored, but haven't already been
  # ignored by the user.
  File.open('.git/info/exclude','a') do |f|
    ignored_files = IgnoredFiles.reject!{|fn| 
      already_ignored.include? fn
    }
    
    puts "Adding ignored files to .git/exclude/info."
    ignored_files.each do |fn|
      f.write(fn+"\n")
    end
  end
end