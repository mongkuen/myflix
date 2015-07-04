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

    it "should set new uploader" do
      get :new
      expect(assigns(:uploader)).to be_a(CoverUploader)
    end
  end
end
