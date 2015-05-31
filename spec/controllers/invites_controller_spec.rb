require 'spec_helper'

describe InvitesController do
  describe "GET new" do
    before { set_current_user }

    it_behaves_like "require sign in" do
      let(:action) { get :new}
    end

    it "should render new" do
      get :new
      expect(response).to render_template :new
    end

    it "should set new invite" do
      get :new
      expect(assigns(:invite)).to be_a_new(Invite)
    end
  end

  describe "POST create" do

    it_behaves_like "require sign in" do
      let(:action) { post :create }
    end

    context "valid invite" do
      let(:invite) { Fabricate.attributes_for(:invite) }
      before do
        set_current_user
        post :create, invite: invite
      end

      after { clear_mailer }

      it "should redirect to invite" do
        expect(response).to redirect_to invites_path
      end

      it "should create invite" do
        expect(Invite.first.email).to eq(invite[:email])
      end

      it "should have user_id of current_user" do
        expect(Invite.first.user).to eq(current_user)
      end

      it "sets success flash" do
        expect(flash[:success]).to be_present
      end

      it "sets token" do
        expect(Invite.first.token).to be_present
      end

      it "should send email" do
        expect(ActionMailer::Base.deliveries).to be_present
      end
    end

    context "invalid invite" do
      let(:invite) { Fabricate.attributes_for(:invite, email: "") }
      before do
        set_current_user
        post :create, invite: invite
      end

      it "should not create invite" do
        expect(Invite.count).to eq(0)
      end

      it "should render new" do
        expect(response).to render_template :new
      end

      it "sets flash error" do
        expect(flash[:danger]).to be_present
      end
    end
  end
end
