require 'spec_helper'

describe User do
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:reviews).order("created_at DESC") }
  it { should have_many(:queue_items).order(:position) }

  describe "#user_queued_video?" do
    it "returns true if user has queued video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(user.user_queued_video?(video)).to eq(true)
    end

    it "returns false if user has not queued video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      video_2 = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(user.user_queued_video?(video_2)).to eq(false)
    end
  end

  describe "#not_yet_followed?" do
    it "returns true if leader not yet followed" do
      user = Fabricate(:user)
      user_2 = Fabricate(:user)
      expect(user.not_yet_followed?(user_2)).to be_truthy
    end

    it "returns false if leader has already been followed" do
      user = Fabricate(:user)
      user_2 = Fabricate(:user)
      followership = Followership.create(leader: user_2, follower: user)
      expect(user.not_yet_followed?(user_2)).to be_falsey
    end
  end

  describe "#notify_user_create" do
    let(:user) { Fabricate(:user, full_name: "User Name") }
    before { user.notify_user_create }
    after { clear_mailer }

    it "sends email to the correct email" do
      expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
    end

    it "sends email with the correct body" do
      expect(ActionMailer::Base.deliveries.last.body).to include("User Name")
    end
  end

  it_behaves_like "tokenable" do
    let(:object) { Fabricate(:user) }
  end

  describe "#notify_password_reset" do
    let(:user) { Fabricate(:user, token: "12345") }
    before { user.notify_password_reset }
    after { clear_mailer }

    it "sends emails to the correct email" do
      expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
    end

    it "sends email with the correct body" do
      expect(ActionMailer::Base.deliveries.last.body).to include("12345")
    end
  end

  describe "#update_password_and_token" do
    let(:user) { Fabricate(:user, token: "12345") }
    before { user.update_password_and_token("new_pass") }

    it "saves new password" do
      expect(User.first.authenticate("new_pass")).to be_truthy
    end

    it "clears token" do
      expect(user.token).to be_nil
    end
  end

  describe "#connect_with_invitors" do
    context "invited" do
      let(:user) { Fabricate(:user) }
      let(:invitor) { Fabricate(:user) }
      let!(:invite) { Fabricate(:invite, user: invitor, email: user.email) }

      it "creates mutual followerships" do
        user.connect_with_invitors
        expect(Followership.first.leader).to eq(invitor)
        expect(Followership.first.follower).to eq(user)
        expect(Followership.last.leader).to eq(user)
        expect(Followership.last.follower).to eq(invitor)
      end

      it "creates one set of followerships from same invitor" do
        invite_2 = Fabricate(:invite, user: invitor, email: user.email)
        user.connect_with_invitors
        expect(Followership.first.leader).to eq(invitor)
        expect(Followership.last.follower).to eq(invitor)
      end

      it "creates multiple followerships from different invitors" do
        invitor_2 = Fabricate(:user)
        invite_2 = Fabricate(:invite, user: invitor_2, email: user.email)
        user.connect_with_invitors
        expect(Followership.count).to eq(4)
        expect(Followership.first.leader).to eq(invitor)
        expect(Followership.last.follower).to eq(invitor_2)
      end
    end

    context "not invited" do
      let(:user) { Fabricate(:user) }

      it "does not create any followerships" do
        user.connect_with_invitors
        expect(Followership.count).to eq(0)
      end
    end
  end
end
