require 'spec_helper'

describe VideosController do

  describe "GET index" do
    it "sets the @categories variable" do
      mystery = Category.create(name: "Mystery")
      comedy = Category.create(name: "Comedy")
      user = User.create(email: "test@test.com", full_name: "test", password: "test")
      session[:user_id] = user.id
      get :index
      expect(assigns(:categories)).to eq([mystery,comedy])
    end

    it "renders the index template" do
      user = User.create(email: "test@test.com", full_name: "test", password: "test")
      session[:user_id] = user.id
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET show" do
    context "with authenticated users" do
      before do
        user = Fabricate(:user)
        session[:user_id] = user.id
      end

      it "sets the @video variable" do
        video = Fabricate(:video)
        get :show, id: video.id
        expect(assigns(:video)).to eq(video)
      end

      it "renders the show template" do
        video = Fabricate(:video)
        get :show, id: video.id
        expect(response).to render_template :show
      end

      it "sets up new @review variable" do
        video = Fabricate(:video)
        get :show, id: video.id
        expect(assigns(:review)).to be_a(Review)
      end
    end

    context "non-authenticated users" do
      it "redirects the user to the home page" do
        video = Fabricate(:video)
        get :show, id: video.id
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "GET search videos" do
    context "With authenticated users" do
      before do
        user = Fabricate(:user)
        session[:user_id] = user.id
      end

      it "Sets the @videos variable" do
        futurama = Fabricate(:video, title: "Futurama")
        3.times do
          Fabricate(:video)
        end
        get :search, search: "Futurama"
        expect(assigns(:videos)).to eq([futurama])
      end

      it "renders the search template" do
        video = Fabricate(:video)
        get :search
        expect(response).to render_template :search
      end
    end

    context "non-authenticated users" do
      it "redirects to the home page" do
        video = Fabricate(:video)
        get :search
        expect(response).to redirect_to root_path
      end
    end
  end

end
