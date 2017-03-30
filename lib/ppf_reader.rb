require 'nokogiri'

class PPFReader
  def initialize(thread)
    @html = thread['html']
  end

  def plans_as_checklist
    convert_lists_to_checklists(plans_html)
  end

  private def plans_html
    def normalize_for_string_matching(element)
      element.to_s.gsub('"', "'")
    end

    page = Nokogiri::HTML(@html)

    plans_h2 = normalize_for_string_matching(page.css('h2')[1])
    fires_h2 = normalize_for_string_matching(page.css('h2')[2])

    @html.split(plans_h2).last.split(fires_h2).first
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
