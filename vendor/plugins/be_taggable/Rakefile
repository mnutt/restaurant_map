require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/clean'
require 'rake/packagetask'
require 'rake/contrib/rubyforgepublisher'
require 'fileutils'
require 'hoe'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the be_taggable plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the be_taggable plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'BeTaggable'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

include FileUtils

@config_file = "~/.rubyforge/user-config.yml"
@config = nil
def rubyforge_username
  unless @config
    begin
      @config = YAML.load(File.read(File.expand_path(@config_file)))
    rescue
      puts <<-EOS
ERROR: No rubyforge config file found: #{@config_file}"
Run 'rubyforge setup' to prepare your env for access to Rubyforge
 - See http://newgem.rubyforge.org/rubyforge.html for more details
      EOS
      exit
    end
  end
  @rubyforge_username ||= @config["username"]
end

RUBYFORGE_PROJECT = 'railers' # The unix name for your project

desc 'Upload be_taggable rdoc files to rubyforge'
task :rdoc_upload do
  host = "#{rubyforge_username}@rubyforge.org"
  remote_dir = "/var/www/gforge-projects/#{RUBYFORGE_PROJECT}/be_taggable"
  local_dir = 'rdoc'
  sh %{rsync -aCv #{local_dir}/ #{host}:#{remote_dir}}
end

desc 'Upload frontpage html to rubyforge'
task :website_upload do
  host = "#{rubyforge_username}@rubyforge.org"
  remote_dir = "/var/www/gforge-projects/#{RUBYFORGE_PROJECT}"
  local_dir = 'website'
  sh %{rsync -aCv #{local_dir}/ #{host}:#{remote_dir}}
end

