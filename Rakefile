# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

require 'spec/rake/spectask'

# Removing the test task and replacing it with spec as the default task
Rake::Task[:default].prerequisites.clear
task :default => :spec

Author = "Jeff Hodges"

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
    # The strip removes the whitespace and newlines that could screw up
    # the reject! statement below. 
    already_ignored = f.readlines.map{|l| l.strip }
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

GPLStatement =<<EOS
# sherlocksampling estimates the number of bugs left in a piece of code.
# Copyright (C) 2008 Jeff Hodges
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

EOS