require 'erb'

class Document
  def initialize(options)
    @first_name = options.fetch(:first_name)
    @week = options.fetch(:week)
    @plans_from_last_week = options.fetch(:plans_from_last_week)
    @pull_requests = options.fetch(:pull_requests)

    prs.each { |pr|
      puts "#{pr['title']} - #{pr['merged_at']} - (#{pr['url']})"
    }

    ## TODO: Create `PullRequest` model object
  end

  def title
    "#{@first_name}’s PPF (#{@week.date_range_string})"
  end

  def contents
    # TODO: Not entirely sure this is necessary
    plans_from_last_week = @plans_from_last_week
    pull_requests = @pull_requests

    template = ERB.new(File.read('template.erb'), nil, '-')

    template.result(binding)
  end
end
