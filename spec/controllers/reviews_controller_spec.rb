require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    context "with authenticated users" do
      before do
        user = Fabricate(:user)
        session[:user_id] = User.first.id
      end

      context "with valid review" do
        before do
          video = Fabricate(:video)
          user = User.find(session[:user_id])
          post :create, id: Video.first.id, review: Fabricate.attributes_for(:review, user: user, video: video)
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
          post :create, id: Video.first.id, review: Fabricate.attributes_for(:review, review: "")
        end

        it "does not save review" do
          expect(Review.count).to eq(0)
        end

        it "renders the show template" do
          expect(response).to render_template 'videos/show'
        end
      end

    end

    context "non-authenticated users" do
      it "redirects to root" do
        video = Fabricate(:video)
        post :create, id: Video.first.id, review: Fabricate.attributes_for(:review)
        expect(response).to redirect_to root_path
      end
    end
  end
end
