#!/usr/bin/ruby

require 'yaml'
require_relative 'lib/quip'
require_relative 'lib/models'
require_relative 'lib/prefer'

config = YAML.load_file('config.yml')

client = PreferQuipClient.new(QuipClient.new(access_token: config['quip_api_token']))

ppf = PPF.new(
  first_name: config['name'],
  week: Week.next
)

client.create(ppf)
