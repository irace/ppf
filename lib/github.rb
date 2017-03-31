require 'unirest'
require 'nokogiri'

class Screenshot
  attr_accessor :name, :URL

  def initialize(options)
    @name = options.fetch(:name)
    @URL = options.fetch(:URL)
  end
end

class PullRequest
  attr_accessor :title, :URL, :screenshots

  def initialize(json)
    @title = json['title']
    @URL = json['html_url']
    @screenshots = extract_screenshots(json['body'])
  end

  private def extract_screenshots(html)
    page = Nokogiri::HTML.fragment(html)
    page.css('img').each_with_index.map { |img, index|
      Screenshot.new(name: index + 1, URL: img['src'])
    }
  end
end

class GitHubClient
  def initialize(options)
    @access_token = options.fetch(:access_token)
    @repository = options.fetch(:repository)
    @user = options.fetch(:user)
    @base_url = 'https://api.github.com/repos'
  end

  def get_pull_requests(week)
    prs = get_json("#{@repository}/pulls", {
      per_page: 50,
      state: 'closed',
      sort: 'updated',
      direction: 'desc'
    })
    .select { |json|
      json['user']['login'] == @user
    }
    .select { |json|
      merge_date = json['merged_at']

      !merge_date.nil? && week.contains(Date.parse(merge_date))
    }.map { |json|
      PullRequest.new(json)
    }
  end

  private def get_json(path, data)
    Unirest.get("#{@base_url}/#{path}", headers: {
        'Authorization' => "token #{@access_token}"
      },
      parameters: data
    ).body
  end
end
