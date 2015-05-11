require 'spec_helper'

describe FollowershipsController do
  describe "GET index" do
    it_behaves_like "require sign in" do
      let(:action) { get :index }
    end

    before { set_current_user }

    it "renders followerships index" do
      get :index
      expect(response).to render_template :index
    end

    it "sets @leading_users" do
      user_2 = Fabricate(:user)
      user_3 = Fabricate(:user)
      followership_1 = Fabricate(:followership, leader: user_2, follower: current_user)
      followership_2 = Fabricate(:followership, leader: user_3, follower: current_user)
      get :index
      expect(assigns(:leaderships)).to include(followership_1, followership_2)
    end

    it "returns @leading_users by most recent first" do
      user_2 = Fabricate(:user)
      user_3 = Fabricate(:user)
      followership_1 = Fabricate(:followership, leader: user_2, follower: current_user)
      followership_2 = Fabricate(:followership, leader: user_3, follower: current_user, created_at: 5.day.ago)
      get :index
      expect(assigns(:leaderships)).to eq([followership_1, followership_2])
    end
  end

  describe "POST create" do
    it_behaves_like "require sign in" do
      let(:action) { post :create, id: 1 }
    end

    before { set_current_user }

    it "redirects to people path" do
      user_2 = Fabricate(:user)
      post :create, id: user_2.id
      expect(response).to redirect_to people_path
    end

    it "creates followership with following current_user" do
      user_2 = Fabricate(:user)
      post :create, id: user_2.id
      expect(Followership.first.leader).to eq(user_2)
      expect(Followership.first.follower).to eq(current_user)
    end

    it "does not follow the same user twice" do
      user_2 = Fabricate(:user)
      post :create, id: user_2.id
      post :create, id: user_2.id
      expect(Followership.count).to eq(1)
    end

    it "does not follow self" do
      post :create, id: current_user.id
      expect(Followership.count).to eq(0)
    end

  end

  describe "DELETE destroy" do
    it_behaves_like "require sign in" do
      let(:action) { delete :destroy, id: 1 }
    end

    before { set_current_user }

    it "redirects to people path" do
      user_2 = Fabricate(:user)
      followership_1 = Fabricate(:followership, leader: user_2, follower: current_user)
      delete :destroy, id: followership_1.id
      expect(response).to redirect_to people_path
    end

    it "deletes followership when current user is follower" do
      user_2 = Fabricate(:user)
      followership_1 = Fabricate(:followership, leader: user_2, follower: current_user)
      delete :destroy, id: followership_1.id
      expect(Followership.count).to eq(0)
    end

    it "does not delete followership if follower is not the current user" do
      user_2 = Fabricate(:user)
      user_3 = Fabricate(:user)
      followership_1 = Fabricate(:followership, leader: user_2, follower: current_user)
      followership_2 = Fabricate(:followership, leader: user_3, follower: user_2)
      delete :destroy, id: followership_2.id
      expect(Followership.count).to eq(2)
    end
  end
end
