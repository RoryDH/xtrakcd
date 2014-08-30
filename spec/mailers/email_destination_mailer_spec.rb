require "rails_helper"

RSpec.describe EmailDestinationMailer, :type => :mailer do
  describe "comic" do
    let(:mail) { EmailDestinationMailer.comic }

    it "renders the headers" do
      expect(mail.subject).to eq("Comic")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
