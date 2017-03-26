#!/usr/bin/ruby
require 'yaml'
require_relative 'lib/client'
require_relative 'lib/ppf'
require_relative 'lib/prefer'

config = YAML.load_file('config.yml')

client = PreferQuipClient.new(QuipClient.new(access_token: config['quip_api_token']))

ppf = PPF.next(config['name'])

client.create(ppf)
