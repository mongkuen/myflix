require 'spec_helper'

describe PasswordResetsController do
  describe "GET new" do
    it_behaves_like "redirects if authenticated" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do
    it_behaves_like "redirects if authenticated" do
      let(:action) { post :create }
    end

    context "valid user email" do
      let(:user) { Fabricate(:user) }
      before { post :create, email: user.email }

      it "generates token" do
        expect(User.first.token).not_to be_nil
      end

      it "sends password reset token email" do
        expect(ActionMailer::Base.deliveries).not_to be_empty
        clear_mailer
      end

      it "redirects to confirmation page" do
        expect(response).to redirect_to confirmation_path
      end

    end

    context "invalid user email" do
      before { post :create, email: "" }
      it "sets flash danger" do
        expect(flash[:danger]).not_to be_empty
      end

      it "redirects to forgot password path" do
        expect(response).to redirect_to forgot_password_path
      end
    end
  end

  describe "GET reset_confirmation" do
    it_behaves_like "redirects if authenticated" do
      let(:action) { get :confirmation }
    end
  end

  describe "GET edit" do
    it_behaves_like "redirects if authenticated" do
      let(:action) { get :edit, id: 123 }
    end

    context "with valid token" do
      let(:user) { Fabricate(:user, token: "12345") }
      before { get :edit, id: "12345" }

      it "sets @user" do
        expect(assigns(:user)).to eq(User.first)
      end
    end

    context "with invalid token" do
      it "redirects to expired token" do
        get :edit, id: "invalid_token"
        expect(response).to redirect_to token_expired_path
      end
    end
  end

  describe "GET expired token" do
    it_behaves_like "redirects if authenticated" do
      let(:action) { get :token_expired }
    end
  end

  describe "POST update" do
    it_behaves_like "redirects if authenticated" do
      let(:action) { post :update }
    end

    context "with valid token" do
      let(:user) { Fabricate(:user, token: "12345") }
      before { post :update, token: user.token, password: "new_password" }

      it "saves new password" do
        expect(User.first.authenticate("new_password")).to be_truthy
      end

      it "deletes token" do
        expect(User.first.token).to be_nil
      end

      it "sets flash success" do
        expect(flash[:success]).not_to be_empty
      end

      it "redirects to login path" do
        expect(response).to redirect_to login_path
      end
    end

    context "with invalid token" do
      it "redirects to expired token" do
        post :update, token: "invalid_token"
        expect(response).to redirect_to token_expired_path
      end
    end
  end
end
