require 'unirest'

class Story
  attr_accessor :title, :URL

  def initialize(json)
    @title = json['name']
    @URL = "https://app.clubhouse.io/prefer/story/#{json['id']}/"
  end
end

class ClubhouseClient
  def initialize(options)
    @access_token = options.fetch(:access_token)
    @owner_id = options.fetch(:owner_id)
    @workflow_state_ids = options.fetch(:workflow_state_ids)
    @base_url = 'https://api.clubhouse.io/api/v1'
  end

  def get_stories
    @workflow_state_ids
      .flat_map { |workflow_state_id|
        post_json("stories/search", {
          workflow_state_id: workflow_state_id,
          archived: false,
          owner_id: @owner_id
        })
      }
      .map { |json|
        Story.new(json)
      }
  end

  private def post_json(path, data)
    Unirest.post("#{@base_url}/#{path}?token=#{@access_token}", parameters: data).body
  end
end
