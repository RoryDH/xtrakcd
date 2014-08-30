class EmailDestinationMailer < ActionMailer::Base
  def self.default_from
    address = Mail::Address.new(Rails.application.config.action_mailer.smtp_settings[:user_name])
    address.display_name = 'xtrakcd.com'
    address.format
  end
  default from: self.default_from

  def comic_notification(email_address, comic)
    @comic = comic
    mail(
      to: email_address,
      subject: "xkcd ##{comic.number}"
    )
  end
end
