#!/usr/bin/env ruby

require 'rubygems'
require 'rack'

class App
  
  def self.desktops=(val)
    @desktops = val
  end
  
  def self.desktops
    @desktops || 6
  end
  
  def self.call(env)
    new(env).dispatch 
  end
  
  def initialize(env)
    @env = env
  end
  
  def dispatch
    switch($1) if desktops.include?(@env['PATH_INFO'][/\/(\d)$/,1].to_i)
    body = links
    [200,{'Content-type' => 'text/html','Content-length'=>body.size.to_s},body]
  end
  
  def switch(desktop_number)
    script = %{
      tell application "System Events"
        keystroke "#{desktop_number}" using control down
      end tell
    }
    system "osascript -e '#{script}'"
  end
  
  def links
    "Desktops: " <<
    desktops.map do |num|
      %{<a href='/#{num}'>#{num}</a>}
    end.join(' | ')
  end
  
  def desktops
    (1..self.class.desktops)
  end
  
end

App.desktops = ARGV.first.to_i unless ARGV.empty?

puts "running on 8080"
Rack::Handler::Mongrel.run App