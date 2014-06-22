module XkcdApi
  include HTTParty
  base_uri 'http://xkcd.com'

  module_function

  def get_number(number)
    comic_params(get_with_errors("/#{number}/info.0.json"))
  end

  def latest
    comic_params(get_with_errors("/info.0.json"))
  end

  def get_with_errors(urn)
    data = nil
    begin
      response = get(urn, { timeout: 22 })
      case response.code
        when 200
          data = JSON.parse(response.body)
        when 404
          data = { error: "404: Not found" }
        when 500...600
          data = { error: "Server error: #{response.code}" }
      end
    rescue Net::ReadTimeout
      data = { error: "timeout" }
    rescue SocketError
      data = { error: "No connection available" }
    end
    data
  end

  def comic_params(i)
    hsh = {
      title:          i["title"],
      safe_title:     i["safe_title"],
      number:         i["num"],
      img_url:        i["img"],
      date_published: Time.new(i["year"] || 0, i["month"], i["day"]),
      alt_text:       i["alt"],
      transcript:     i["transcript"],
      special_link:   i["link"],
      news:           i["news"]
    }
    hsh.each { |k, v| hsh[k] = nil if v == "" }
  end
end
