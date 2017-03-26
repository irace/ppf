# http://stackoverflow.com/a/7930553/503916
def date_of_next(day)
  date = Date.parse(day)
  delta = date > Date.today ? 0 : 7
  date + delta
end

class PPF
  attr_reader :start_date, :end_date, :first_name

  def self.next(first_name)
    # TODO: What would happen if you ran this on e.g. Saturday?
    return PPF.new(
      :first_name => first_name,
      :start_date => date_of_next('Monday'),
      :end_date => date_of_next('Sunday')
    )
  end

  def initialize(options)
    @first_name = options.fetch(:first_name)
    @start_date = options.fetch(:start_date)
    @end_date = options.fetch(:end_date)
  end

  def date_range
    "#{start_date.month}/#{start_date.day} - #{end_date.month}/#{end_date.day}"
  end

  def folder_title
    "Week of #{date_range}"
  end

  def title
    "#{first_name}’s PPF (#{date_range})"
  end

  def contents
    template = File.open('ppf.md', 'rb').read
  end
end
