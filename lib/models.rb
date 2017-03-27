class Week
  def self.next
    Week.new(Date.parse('Monday'))
  end

	def initialize(start_date)
		@start_date = start_date
		@end_date = start_date + Date::DAYNAMES.count - 1
	end

	def previous
		Week.new(@start_date - Date::DAYNAMES.count)
	end

  def start_date_string
    "#{@start_date.month}/#{@start_date.day}"
  end

  def folder_title
    "Week of #{date_range_string}"
  end

  def date_range_string
    "#{start_date_string} - #{@end_date.month}/#{@end_date.day}"
  end

	def to_s
		"#{super.to_s}: #{@start_date} - #{@end_date}"
	end
end

class PPF
  attr_reader :week, :first_name

  def initialize(options)
    @first_name = options.fetch(:first_name)
    @week = options.fetch(:week)
  end

  def title
    "#{@first_name}’s PPF (#{@week.date_range_string})"
  end

  def contents
    template = File.open('ppf.md', 'rb').read
  end
end
