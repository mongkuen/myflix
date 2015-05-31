require 'spec_helper'

describe UsersController do
  describe "GET new:" do
    context "no invite token" do
      it "Sets @user variable" do
        get :new
        expect(assigns[:user]).to be_a(User)
      end
    end

    context "invite token present" do
      let!(:invite) { Fabricate(:invite, token: "1234") }
      before { get :new, token: "1234" }

      it "Sets @user with invite email and name" do
        expect(assigns[:user].full_name).to eq(invite.name)
        expect(assigns[:user].email).to eq(invite.email)
      end
    end

    it_behaves_like "redirects if authenticated" do
      let(:action) { get :new }
    end
  end

  describe "POST create:" do
    context "User not logged in:" do
      context "Input valid:" do
        before { post :create, user: Fabricate.attributes_for(:user) }

        it "Saves user" do
          expect(User.count).to eq(1)
        end

        it "Sets user login session" do
          expect(session[:user_id]).to eq(User.first.id)
        end

        it "Redirects to root" do
          expect(response).to redirect_to root_path
        end

        it "sends email" do
          expect(ActionMailer::Base.deliveries).to be_present
          clear_mailer
        end
      end

      context "User is invited" do
        let(:invite) { Fabricate(:invite) }
        let(:user) { Fabricate.attributes_for(:user, email: invite.email) }

        it "creates two followerships" do
          post :create, user: user
          expect(Followership.count).to eq(2)
        end
      end

      context "Input invalid:" do
        before do
          post :create, user: Fabricate.attributes_for(:user, email: "")
        end

        it "Does not save user" do
          expect(User.count).to eq(0)
        end

        it "Sets @user variable" do
          expect(assigns[:user]).to be_a(User)
        end

        it "renders the new template" do
          expect(response).to render_template :new
        end
      end
    end

    it_behaves_like "redirects if authenticated" do
      let(:action) { post :create }
    end
  end

  describe "GET show" do
    it_behaves_like "require sign in" do
      let(:action) do
        Fabricate(:user)
        get :show, id: 1
      end
    end

    before { set_current_user }

    it "sets @user" do
      get :show, id: current_user.id
      expect(assigns(:user)).to eq(current_user)
    end

    it "renders user show" do
      get :show, id: current_user.id
      expect(response).to render_template :show
    end
  end
end
