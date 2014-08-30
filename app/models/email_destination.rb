class EmailDestination < Destination
  typed_store_accessor :settings,
    'email_address'          => nil,
    'email_address_verified' => lambda { |v| v == "true" }

  def deliver(comic)
    email = EmailDestinationMailer.comic_notification(self.email_address, comic)
    email.deliver
  end
  
end
