require_dependency 'oneboxer/handlebars_onebox'

# Disclaimer: I have never written a line of Ruby before in my life.
# If I have done anything silly, please correct it and submit a pull request :)

module Oneboxer
  class TwobuntuOnebox < HandlebarsOnebox
    
    matcher /^http:\/\/(www\.)?2buntu\.com/
    favicon 'twobuntu.png'
    
    # Translates the post URL into a URL for accessing the public API.
    def translate_url
      m = @url.match(/2buntu\.com\/(?<id>\d+)/)
      return "http://2buntu.com/api/articles/#{m[:id]}/" if m
    end
    
    # Parses the 2buntu JSON data returned by the API.
    # TODO: I'm not sure if error checking could be improved here or not.
    def parse(data)
      result = JSON.parse(data)['articles'].first
      result['body'] = BaseOnebox.replace_tags_with_spaces(result['body'])
      if result['body'].length > 400
        result['body'] = result['body'][0..400]
        result['body'] << "..."
      end
      # Shamelessly stolen from the SE onebox and adapted.
      result['creation_date'] = Time.at(result['creation_date'].to_i).strftime("%B %e, %Y")
      result
    end
    
  end
end
