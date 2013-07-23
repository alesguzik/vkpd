# -*- coding: utf-8; mode: ruby -*-
require 'net/http'
require 'net/https'
require 'cgi'
require 'yaml'
require 'json'
require 'pathname'
require 'sinatra/base'
require 'ruby-mpd'
require 'vkpd/version'
require 'vkpd/cli'
require 'vkpd/auth'

module Vkpd
  APP_ID='2803517'
  
  class <<self
    def config_path
      @config_path ||= "#{ENV['HOME']}/.config/vkpd.yaml"
    end

    # Reads config file, parses it as yaml and caches the result
    def config
      unless File.exist? config_path
        puts 'Please authenticate. Type `vkpd auth` and point your browser to http://localhost.localdomain:4567/'
        exit 1
      end
      @config ||= YAML.load File.read(config_path)
    end
  end

end
