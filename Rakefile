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
IgnoredFiles = [ 
  "config/database.yml", 
  "log/*.log",
  "log/*.pid",
  "db/*.sqlite3"
]

# The list of gems that can't be simply copied into vendor/gems
HardGems = [ 
  ["sqlite3-ruby", "1.2.1"],
  ["mysql"]
]
    
desc "Set up the local copy of sherlocksampling for development."
task :setup => [:add_ignored_files_to_git, :check_for_hard_gems, "db:create", "db:schema:load"]

desc "Check for the hard gems to install."
task :check_for_hard_gems do
  not_installed = []
  gems = Gem::SourceIndex.from_installed_gems
  
  HardGems.each do |g|
    if gems.search(g[0], g[1]).empty?
      not_installed << g
    end
  end
  
  if not_installed.empty?
    puts "All necessary gems installed."
  else
    puts "You still need to install these gems:"
    not_installed.each do |g|
      if g[1] # Kludgy, but does the Right Thing.
        puts "\t#{g[0]} -v #{g[1]}"
      else
        puts "\t#{g[0]}"
      end
    end
    puts "You can install them easily by running `rake install_hard_gems`"
    exit 1
  end
end

desc "Install the gems that can't be simply copied into vendor/gems. Probably, needs to be run as root."
task :install_hard_gems do
  HardGems.map do |g|
    gems = Gem::SourceIndex.from_installed_gems 
    # Stolen liberally from http://blog.labnotes.org/2008/02/28/svn-checkout-rake-setup/
    if gems.search(g[0], g[1]).empty?
      begin 
        require 'rubygems/dependency_installer'
        Gem::DependencyInstaller.new(g[0], g[1]).install
      rescue LoadError # < rubygems 1.0.1
        require 'rubygems/remote_installer'
        Gem::RemoteInstaller.new.install(dep.name, dep.version_requirements)
      end
    end
  end
end

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
    
    if ignored_files.empty?
      puts "All ignored files are in .git/exclude/info already. Way to go! Yay!"
    else
      puts "Adding ignored files to .git/exclude/info."
      ignored_files.each do |fn|
        f.write(fn+"\n")
      end
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