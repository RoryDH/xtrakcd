module XkcdApi
  include HTTParty
  base_uri 'http://xkcd.com'

  module_function

  def get_number(number)
    hsh = comic_params(get_with_errors("/#{number}/info.0.json"))
    hsh[:number] ||= number
    hsh
  end

  def latest
    comic_params(get_with_errors("/info.0.json"))
  end

  def get_with_errors(urn)
    begin
      response = get(urn, { timeout: 22 })
      case response.code
        when 200
          JSON.parse(response.body)
        when 404
          { error: "404: Not found" }
        when 500...600
          { error: "Server error: #{response.code}" }
      end
    rescue Net::ReadTimeout
      { error: "timeout" }
    rescue SocketError
      { error: "No connection available" }
    end
  end

  def comic_params(i)
    hsh = {
      title:          i["title"],
      safe_title:     i["safe_title"],
      number:         i["num"],
      img_url:        i["img"],
      alt_text:       i["alt"],
      transcript:     i["transcript"],
      special_link:   i["link"],
      news:           i["news"]
    }
    if i['year'] 
      hsh[:date_published] = Time.new(i["year"], i["month"], i["day"])
    end
    hsh.each { |k, v| hsh[k] = nil if v == "" }
  end
end
