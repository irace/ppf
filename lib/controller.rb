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

    unless last_ppf.nil?
      plans_from_last_week = PPFReader.new(last_ppf).plans_as_checklist
    else
      plans_from_last_week = nil
    end

    ppf = Document.new(
      first_name: first_name,
      week: week,
      plans_from_last_week: plans_from_last_week,
      pull_requests: @github && @github.get_pull_requests(week.previous),
      stories: @clubhouse && @clubhouse.get_stories
    )

    folder = in_private_directory ? @file_system.find_private_folder : @file_system.find_or_create_ppf_folder(week)

    response = @file_system.create_ppf(
      document: ppf,
      folder: folder
    )

    `open #{response['thread']['link']}`

    puts "Created '#{ppf.title}'!"
  end
end
