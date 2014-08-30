class EmailDestinationMailerPreview < ActionMailer::Preview
  def comic_notification
    user = User.first
    comic = Comic.random
    EmailDestinationMailer.comic_notification(user, comic)
  end
end
