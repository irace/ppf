require_relative 'document'
require_relative 'ppf_reader'

class Controller
  def initialize(file_system, github, clubhouse)
    @file_system = file_system
    @github = github
    @clubhouse = clubhouse
  end

  # thread_html = @quip.get_thread('9aryA5mVrkyi')['html']
  # puts thread_html

  # TODO: https://developers.google.com/google-apps/calendar/quickstart/ruby
  # TODO: https://clubhouse.io/api/v1/#stories

  def create(options)
    first_name = options.fetch(:first_name)
    week = options.fetch(:week)

    last_ppf = @file_system.find_ppf_thread(week: week.previous, first_name: first_name)

    ppf = Document.new(
      first_name: first_name,
      week: week,
      plans_from_last_week: PPFReader.new(last_ppf).plans_as_checklist,
      pull_requests: @github.get_pull_requests(week),
      stories: @clubhouse.get_stories
    )

    puts ppf.contents

    # @file_system.create_ppf(
    #   document: ppf,
    #   folder: @file_system.find_or_create_ppf_folder(week) # TODO: Option for private vs. public location
    # )

    #puts "Created '#{ppf.title}'!"
  end
end
