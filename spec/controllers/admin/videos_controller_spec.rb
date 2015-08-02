require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    before { set_admin }

    it_behaves_like "require sign in" do
      let(:action) { get :new }
    end

    it_behaves_like "require admin" do
      let(:action) { get :new }
    end

    it "should render admin new video template" do
      get :new
      expect(response).to render_template :new
    end

    it "should set new video variable" do
      get :new
      expect(assigns(:video)).to be_a_new(Video)
    end

  end

  describe "POST create" do
    before { set_admin }

    it_behaves_like "require sign in" do
      let(:action) { post :create }
    end

    it_behaves_like "require admin" do
      let(:action) { post :create }
    end

    context "with valid inputs" do
      before do
        post :create, video: Fabricate.attributes_for(:video)
      end

      it "saves @video" do
        expect(Video.count).to eq(1)
      end

      it "sets success flash" do
        expect(flash[:success]).not_to be_empty
      end

      it "redirects to admin new videos path" do
        expect(response).to redirect_to new_admin_video_path
      end
    end

    context "with invalid inputs" do
      before do
        post :create, video: Fabricate.attributes_for(:video, title: "")
      end

      it "does not save @video" do
        expect(Video.count).to eq(0)
      end

      it "sets danger flash" do
        expect(flash[:danger]).not_to be_empty
      end

      it "sets the @video variable" do
        expect(assigns(:video)).to be_present
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end
    end

  end
end
