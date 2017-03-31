require_relative 'document'
require_relative 'ppf_reader'

class Controller
  def initialize(file_system, github, clubhouse)
    @file_system = file_system
    @github = github
    @clubhouse = clubhouse
  end

  def create(options)
    first_name = options.fetch(:first_name)
    week = options.fetch(:week)
    in_private_directory = options.fetch(:in_private_directory)

    last_ppf = @file_system.find_ppf_thread(week: week.previous, first_name: first_name)

    ppf = Document.new(
      first_name: first_name,
      week: week,
      plans_from_last_week: PPFReader.new(last_ppf).plans_as_checklist,
      pull_requests: @github.get_pull_requests(week),
      stories: @clubhouse.get_stories
    )

    folder = in_private_directory ? @file_system.find_private_folder : @file_system.find_or_create_ppf_folder(week)

    @file_system.create_ppf(
      document: ppf,
      folder: folder
    )

    puts "Created '#{ppf.title}'!"
  end
end
