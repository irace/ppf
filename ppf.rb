#!/usr/bin/ruby

require 'yaml'
require_relative 'lib/github'
require_relative 'lib/quip'
require_relative 'lib/week'
require_relative 'lib/controller'

config = YAML.load_file('config.yml')

controller = Controller.new(
  QuipClient.new(
    access_token: config['quip.api_token']
  ),
  GitHubClient.new(
    access_token: config['github.api_token'],
    repository: config['github.repository'],
    user: config['github.user_name']
  )
)

controller.create(
  first_name: config['user.first_name'],
  week: Week.next
)
