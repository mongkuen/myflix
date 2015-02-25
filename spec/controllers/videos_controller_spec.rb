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

  describe "POST review" do
    context "with authenticated users" do
      before do
        user = Fabricate(:user)
        session[:user_id] = User.first.id
      end

      context "with valid review" do
        before do
          video = Fabricate(:video)
          user = User.find(session[:user_id])
          post :review, id: Video.first.id, review: Fabricate.attributes_for(:review, user: user, video: video)
        end

        it "saves review" do
          expect(Review.count).to eq(1)
        end

        it "associates review with logged in current user" do
          expect(Review.first.user).to eq(User.first)
        end

        it "associates review with video" do
          expect(Review.first.video).to eq(Video.first)
        end

        it "redirects to show video" do
          expect(response).to redirect_to video_path(Video.first.id)
        end
      end

      context "with invalid review" do
        before do
          video = Fabricate(:video)
          post :review, id: Video.first.id, review: Fabricate.attributes_for(:review, review: "")
        end

        it "does not save review" do
          expect(Review.count).to eq(0)
        end

        it "renders the show template" do
          expect(response).to render_template :show
        end
      end

    end

    context "non-authenticated users" do
      it "redirects to root" do
        video = Fabricate(:video)
        post :review, id: Video.first.id, review: Fabricate.attributes_for(:review)
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
