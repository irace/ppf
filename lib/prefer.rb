require 'nokogiri'

class PreferQuipClient
  def initialize(client)
    @client = client
    @parent_folder_id = 'PeIAOAYg2AN'
  end

  def create(ppf)
    this_weeks_ppf_folder = find_or_create_ppf_folder(ppf.week)

    last_weeks_ppf = find_ppf_thread(ppf.week.previous, ppf.first_name))

    # TODO: ERB template this in. Try inserting into Markdown first. Else, convert template to HTML
    plans_from_last_week = extract_plans_as_checklist(last_weeks_ppf)

    @client.create_document(ppf.contents, {
      title: ppf.title,
      format: 'markdown',
      member_ids: [this_weeks_ppf_folder['folder']['id']]
    })

    puts "Created '#{ppf.title}'!"
  end

  private def create_folder(title, parent_folder_id)
    @client.create_folder({
      title: title,
      parent_id: parent_folder_id
    })
  end

  private def find_or_create_ppf_folder(week)
    ppf_folder = find_ppf_folder(week)

    if ppf_folder.nil?
      puts 'PPF folder hasn’t been added yet. Creating it...'
      ppf_folder = create_folder(ppf.week.folder_title, @parent_folder_id)
    end

    ppf_folder
  end

  private def find_ppf_folder(week)
    # TODO: Look this folder up from _it’s_ parent, based on the current year
    parent_folder = @client.get_folder(@parent_folder_id)

    children_ids = parent_folder['children'].map { |child|
      child['folder_id']
    }.join(',')

    children_folders = @client.get_folders(children_ids)

    children_folders.values.find { |child|
      child['folder']['title'].include? week.start_date_string
    }
  end

  private def find_ppf_thread(week, first_name)
    last_weeks_ppf_folder = find_ppf_folder(week)

    children_ids = last_weeks_ppf_folder['children'].map { |child|
      child['thread_id']
    }.join(',')

    threads = @client.get_threads(children_ids)

    threads.values.find { |thread|
      thread['thread']['title'].include? first_name
    }
  end

  private def extract_plans_as_checklist(thread)
    convert_lists_to_checklists(extract_plans(thread))
  end

  private def extract_plans(thread)
    def normalize_for_string_matching(element)
      element.to_s.gsub('"', "'")
    end

    html = thread['html']

    page = Nokogiri::HTML(html)

    plans_h2 = normalize_for_string_matching(page.css('h2')[1])
    fires_h2 = normalize_for_string_matching(page.css('h2')[2])

    html.split(plans_h2).last.split(fires_h2).first
  end

  private def convert_lists_to_checklists(html)
    page = Nokogiri::HTML(html)

    page.css('ul').each { |list|
      list['class'] = 'checked'
    }

    page
  end
end
