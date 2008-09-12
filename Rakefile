require 'rubygems'
require 'rake'
require 'spec/rake/spectask'
require File.dirname(__FILE__) + '/app/weather'

desc "Create database"
task :setup do
  Weather.connect

  ActiveRecord::Base.connection.drop_table :reports rescue nil
  ActiveRecord::Base.connection.create_table :reports do |t|
    t.integer :condition
    t.integer :temperature
    t.string  :tweet
    t.timestamps
  end
end

desc "Run specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ['--colour --format progress --loadby mtime --reverse']
  t.spec_files = FileList['spec/*_spec.rb']
end
task :default => :spec

desc "Execute it!"
task :run do
  Weather.run
end

desc "Simulation"
task :simulate do
  loop do
    Weather.run
    sleep(5)
  end
end