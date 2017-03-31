require 'erb'

class Document
  def initialize(options)
    @first_name = options.fetch(:first_name)
    @week = options.fetch(:week)
    @plans_from_last_week = options.fetch(:plans_from_last_week)
    @pull_requests = options.fetch(:pull_requests)
    @stories = options.fetch(:stories)
  end

  def title
    "#{@first_name}’s PPF (#{@week.date_range_string})"
  end

  def contents
    template = ERB.new(File.read('lib/template.erb'), nil, '-')

    template.result(binding)
  end
end
