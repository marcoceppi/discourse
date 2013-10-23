require 'open-uri'
require_dependency 'oneboxer/handlebars_onebox'

module Oneboxer
  class LaunchpadBazaarOnebox < HandlebarsOnebox

    matcher /^https?:\/\/bazaar\.launchpad\.net\/[^\/]+\/[^\/]+\/[^\/]+\/?[^\/]+\/?[^\/]+\/?[^\/]+\/view\/[A-z0-9]+:\/.*/
    favicon 'bazaar.png'

    def translate_url
      # IANARD - I am not a ruby developer.
      page_html = open(@url).read
      return nil if page_html.blank?
      doc = Nokogiri::HTML(page_html)
      download_link_el = doc.at_css("ul#submenuTabs li#last a")
      return "https://bazaar.launchpad.net/" + download_link_el['href']
    end

    def parse(data)

#      if @from > 0
#        if @to < 0
#          @from = @from - 10
#          @to = @from + 20
#        end
#        if @to > @from
#          data = data.split("\n")[@from..@to].join("\n")
#        end
#      end

      extension = @url.split(".")[-1]
      @lang = case extension
                when "rb" then "ruby"
                when "js" then "javascript"
                when "py" then "python"
                else extension
             end

      truncated = false
      if data.length > SiteSetting.onebox_max_chars
        data = data[0..SiteSetting.onebox_max_chars-1]
        truncated = true
      end

      {content: data, truncated: truncated}
    end

  end
end
