#!/usr/bin/ruby

require 'yaml'
require_relative 'lib/clubhouse'
require_relative 'lib/github'
require_relative 'lib/quip'
require_relative 'lib/week'
require_relative 'lib/controller'
require_relative 'lib/file_system'

config = YAML.load_file('config.yml')

controller = Controller.new(
  FileSystem.new(
    QuipClient.new(
      access_token: config['quip']['api_token']
    )
  ),
  GitHubClient.new(
    access_token: config['github']['api_token'],
    repository: config['github']['repository'],
    user: config['github']['user_name']
  ),
  ClubhouseClient.new(
    access_token: config['clubhouse']['api_token'],
    owner_id: config['clubhouse']['owner_id'],
    workflow_state_id: config['clubhouse']['workflow_state_id']
  )
)

controller.create(
  first_name: config['user']['first_name'],
  week: Week.next
)
