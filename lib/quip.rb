require 'unirest'

class QuipClient
  def initialize(options)
    @access_token = options.fetch(:access_token)
    @base_url = options.fetch(:base_url, 'https://platform.quip.com/1')
  end

  def get_authenticated_user
    get_json('users/current')
  end

  def create_document(content, options = {})
    post_json("threads/new-document", {
      content: content,
      format: options.fetch(:format, 'html'),
      title: options.fetch(:title, nil),
      member_ids: options.fetch(:member_ids, []).join(',')
    })
  end

  def create_folder(options)
    post_json('folders/new', options)
  end

  def get_thread(id)
    get_json("threads/#{id}")
  end

  def get_threads(ids)
    get_json("threads/?ids=#{ids}")
  end

  def get_folder(id)
    get_json("folders/#{id}")
  end

  def get_folders(ids)
    get_json("folders/?ids=#{ids}")
  end

  private def get_json(path)
    Unirest.get("#{@base_url}/#{path}", headers: {
      'Authorization' => "Bearer #{@access_token}"
    }).body
  end

  private def post_json(path, data)
    Unirest.post("#{@base_url}/#{path}", headers: {
      'Authorization' => "Bearer #{@access_token}"
      },
      parameters: data
    ).body
  end
end
