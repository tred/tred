#!/usr/bin/env ruby

require 'rubygems'
require 'rack'

class App
  
  def self.call(env); new(env).dispatch end
  
  attr_reader :env
  
  def initialize(env)
    @env = env
  end
    
  def people
    { 1 => 'Carl', 2 => 'Myles', 3 => 'Mike' }
  end
  
  def links
    people.sort_by {|n| n}.map do |num,name|
      %{<a href='/#{num}'>#{name} (#{num})</a>}
    end.join(' | ')
  end
  
  def switch(desktop_number)
    script = %{
      tell application "System Events"
        keystroke "#{desktop_number}" using control down
      end tell
    }
    #system %[osascript -e 'tell application "System Events" \n tell process "Finder" to keystroke "#{desktop_number}" using control down']
    system "osascript -e '#{script}'"
  end
  
  def dispatch
    switch($1) if env['PATH_INFO'] =~ /^\/(\d)$/
    body = links
    [200,{'Content-length'=>body.size.to_s},body]
  end
  
end

Rack::Handler::Mongrel.run App