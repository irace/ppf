class PreferQuipClient
  def initialize(client)
    @client = client
    @parent_folder_id = 'PeIAOAYg2AN'
  end

  def create(ppf)
    ppf_folder = find_ppf_folder(ppf.folder_title)

    if ppf_folder.nil?
      ppf_folder = create_folder(ppf.folder_title, parent_folder_id)
    end

    client.create_document(ppf.contents, {
     :title => ppf.title,
     :format => 'markdown',
     :member_ids => [ppf_folder['folder']['id']]
    })
  end

  private def create_folder(title, parent_folder_id)
    client.create_folder({
      title: title,
      parent_id: parent_folder_id
    })
  end

  private def find_ppf_folder(folder_title)
    # TODO: Move this ID into a constant
    # TODO: Look this up based on the current year
    parent_folder = client.get_folder(parent_folder_id)
    children_ids = parent_folder['children'].map { |e| e['folder_id'] }.join(',')
    children_folders = client.get_folders(children_ids)
    children_folders.values.select { |e| e['folder']['title'] == folder_title }.first
  end
end
