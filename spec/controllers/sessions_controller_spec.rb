require 'spec_helper'

describe SessionsController do
  context "User not logged in:" do
    describe "GET new:" do
      it "Renders the new template" do
        get :new
        expect(response).to render_template :new
      end
    end

    describe "POST create:" do
      context "User exists and authenticates:" do
        before do
          user = Fabricate(:user)
          post :create, email: user.email, password: user.password
        end

        it "Should set sessions to user_id" do
          expect(session[:user_id]).to eq(User.first.id)
        end

        it "Should redirect to home" do
          expect(response).to redirect_to root_path
        end
      end

      context "User login invalid:" do
        let(:user) { Fabricate(:user) }

        it "Should redirect to login path if user does not exist" do
          post :create, email: user.email + "bademail"
          expect(response).to redirect_to login_path
        end

        it "Should redirect to login path if user does not authenticate" do
          post :create, email: user.email, password: user.password + "badpass"
          expect(response).to redirect_to login_path
        end

        it "Does not put user in session" do
          post :create, email: user.email
          expect(session[:user_id]).to be_nil
        end

        it "Sets error message" do
          post :create, email: user.email
          expect(flash[:danger]).not_to be_blank
        end
      end
    end

    describe "GET destroy:" do
      it "Should set sessions[:user_id] to nil" do
        get :destroy
        expect(session[:user_id]).to eq(nil)
      end

      it "Should redirect to root path" do
        get :destroy
        expect(response).to redirect_to root_path
      end
    end
  end

  context "User logged in:" do
    before do
      user = Fabricate(:user)
      session[:user_id] = User.first.id
    end

    describe "GET new:" do
      it "Should redirect to home" do
        get :new
        expect(response).to redirect_to home_path
      end
    end

    describe "POST create:" do
      it "Should redirect to home" do
        post :create
        expect(response).to redirect_to home_path
      end
    end

    describe "GET destroy:" do
      it "Should set sessions[:user_id] to nil" do
        get :destroy
        expect(session[:user_id]).to eq(nil)
      end

      it "Should redirect to root path" do
        get :destroy
        expect(response).to redirect_to root_path
      end
    end

  end
end
