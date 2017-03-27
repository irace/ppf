require 'nokogiri'

class Controller
  def initialize(quip, github)
    @quip = client
    @github = github
    @parent_folder_id = 'PeIAOAYg2AN'
  end

  def create(first_name, week)
    # thread_html = @quip.get_thread('9aryA5mVrkyi')['html']
    # puts thread_html

    this_weeks_ppf_folder = find_or_create_ppf_folder(week)

    last_weeks_ppf = find_ppf_thread(week.previous, first_name)

    ppf = Document.new(
      first_name: config['name'],
      week: Week.next,
      plans_from_last_week: extract_plans_as_checklist(last_weeks_ppf),
      pull_requests: @github.get_pull_requests(week)
    )

    @quip.create_document(ppf.contents, {
      title: ppf.title,
      format: 'markdown',
      member_ids: ['WUYAOAUmDC9']#[this_weeks_ppf_folder['folder']['id']]
    })

    puts "Created '#{ppf.title}'!"
  end

  private def find_or_create_ppf_folder(week)
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

  private def find_ppf_thread(week, first_name)
    last_weeks_ppf_folder = find_ppf_folder(week)

    children_ids = last_weeks_ppf_folder['children'].map { |child|
      child['thread_id']
    }.join(',')

    threads = @quip.get_threads(children_ids)

    threads.values.find { |thread|
      thread['thread']['title'].include? first_name
    }
  end

  private def extract_plans_as_checklist(thread)
    convert_lists_to_checklists(extract_plans(thread))
  end

  # TODO: Extract this out

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
    page = Nokogiri::HTML.fragment(html)

    page.css('li').each { |item|
      item['class'] = 'checked'
    }

    page.css('br').remove

    page
  end
end
