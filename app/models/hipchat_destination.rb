class HipchatDestination < Destination
  typed_store_accessor :settings,
    'api_key'     => nil,
    'room'        => nil

  validates :api_key, length: { in: 30..40 }
  validates :room, length: { in: 1..100 }

  HIPCHAT_MESSAGE_HTML = %Q(
    <a href="%s">
      new comic '%s'
      <br>
      <img src="%s">
    </a>
  )

  def deliver(comic)
    client = HipChat::Client.new(api_key, api_version: 'v1')
    html = HIPCHAT_MESSAGE_HTML % ['http://linktocomic.com', comic.title, comic.img_url]
    client[room].send('xtrakcd', html)
  end
end
