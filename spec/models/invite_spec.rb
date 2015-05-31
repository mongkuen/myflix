require 'spec_helper'

describe Invite do
  it { should belong_to :user }
  it { should validate_presence_of :email }

  describe "#send_invite" do
    let(:invite) { Fabricate(:invite, name: "Adam Apple") }
    before { invite.send_invite }
    after { clear_mailer }

    it "sends to the right address" do
      expect(ActionMailer::Base.deliveries.last.to).to eq([invite.email])
    end

    it "has the right content" do
      expect(ActionMailer::Base.deliveries.last.body).to include("Adam Apple")
    end
  end
end
