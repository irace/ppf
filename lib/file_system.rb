class FileSystem
  def initialize(quip)
    @quip = quip

    @parent_folder_id = 'PeIAOAYg2AN'
  end

  def create_ppf(options)
    ppf = options.fetch(:document)
    folder = options.fetch(:folder)

    @quip.create_document(ppf.contents, {
      title: ppf.title,
      format: 'markdown',
      member_ids: [folder['folder']['id']]
    })
  end

  def find_private_folder
    @quip.get_authenticated_user['private_folder_id']
  end

  def find_ppf_thread(options)
    folder = find_ppf_folder(options.fetch(:week))

    children_ids = folder['children'].map { |child|
      child['thread_id']
    }.reject { |id| id.nil? }.join(',')

    threads = @quip.get_threads(children_ids)

    threads.values.find { |thread|
      thread['thread']['title'].include? options.fetch(:first_name) 
    }
  end

  def find_or_create_ppf_folder(week)
    ppf_folder = find_ppf_folder(week)

    if ppf_folder.nil?
      puts 'PPF folder hasn’t been added yet. Creating it...'

      ppf_folder = @quip.create_folder({
        title: week.folder_title,
        parent_id: @parent_folder_id
      })
    end

    ppf_folder
  end

  private def find_ppf_folder(week)
    # TODO: Look this folder up from _it’s_ parent, based on the current year
    parent_folder = @quip.get_folder(@parent_folder_id)

    children_ids = parent_folder['children'].map { |child|
      child['folder_id']
    }.join(',')

    children_folders = @quip.get_folders(children_ids)

    children_folders.values.find { |child|
      child['folder']['title'].include? week.start_date_string
    }
  end
end
