require 'spec_helper'

describe UsersController do
  describe "GET new:" do
    context "User not logged in:" do
      it "Sets @user variable" do
        get :new
        expect(assigns[:user]).to be_a(User)
      end
    end

    context "User logged in:" do
      it "Redirects to home" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        get :new
        expect(response).to redirect_to home_path
      end
    end
  end

  describe "POST create:" do
    context "User not logged in:" do
      context "Input valid:" do
        before do
          post :create, user: Fabricate.attributes_for(:user)
        end

        it "Saves user" do
          expect(User.count).to eq(1)
        end

        it "Sets user login session" do
          expect(session[:user_id]).to eq(User.first.id)
        end

        it "Redirects to root" do
          expect(response).to redirect_to root_path
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

    context "User logged in" do
      it "redirects you to home" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        post :create
        expect(response).to redirect_to home_path
      end
    end
  end
end
