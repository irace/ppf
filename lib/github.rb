require 'unirest'

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
    .select { |pr|
      pr['user']['login'] == @user
    }
    .select { |pr|
      merge_date = pr['merged_at']

      !merge_date.nil? && week.contains(Date.parse(merge_date))
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
