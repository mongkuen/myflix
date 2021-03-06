require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "Sets @queue_items to the queue items of the logged in user" do
      user = Fabricate(:user)
      session[:user_id] = User.first.id
      queue_item1 = Fabricate(:queue_item, user: user)
      queue_item2 = Fabricate(:queue_item, user: user)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it_behaves_like "require sign in" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    it "should redirect to the my queue path" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end

    it "should create a queue item" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it "creates the queue item that is associated with the video" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end

    it "creates the queue item that is associated with the current user" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(current_user)
    end

    it "puts the video as the last one in the queue" do
      set_current_user
      video1 = Fabricate(:video)
      Fabricate(:queue_item, video: video1, user: current_user)
      video2 = Fabricate(:video)
      post :create, video_id: video2.id
      video2_queue_item = QueueItem.where(video_id: video2.id, user_id: current_user.id).first
      expect(video2_queue_item.position).to eq(2)
    end

    it "does not add the video to the queue if the video is already in the queue" do
      set_current_user
      video1 = Fabricate(:video)
      Fabricate(:queue_item, video: video1, user: current_user)
      post :create, video_id: video1.id
      expect(current_user.queue_items.count).to eq(1)
    end

    it_behaves_like "require sign in" do
      let(:action) { post :create }
    end
  end

  describe "DELETE destroy" do
    it "redirects to the myqueue page" do
      set_current_user
      queue_item = Fabricate(:queue_item)
      delete :destroy, id:  queue_item.id
      expect(response).to redirect_to my_queue_path
    end

    it "deletes the queue item" do
      set_current_user
      queue_item = Fabricate(:queue_item, user: current_user)
      delete :destroy, id:  queue_item.id
      expect(QueueItem.count).to eq(0)
    end

    it "normalizes queue items" do
      set_current_user
      queue_item_1 = Fabricate(:queue_item, user: current_user, position: 1)
      queue_item_2 = Fabricate(:queue_item, user: current_user, position: 2)
      queue_item_3 = Fabricate(:queue_item, user: current_user, position: 3)
      delete :destroy, id:  queue_item_2.id
      expect(queue_item_3.reload.position).to eq(2)
    end

    it "does not relete the queue item if the queue item is not in the current user's queue" do
      set_current_user
      user2 = Fabricate(:user)
      session[:user_id] = current_user.id
      queue_item = Fabricate(:queue_item, user: user2)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end

    it_behaves_like "require sign in" do
      let(:action) { delete :destroy, id: 3 }
    end

  end

  describe "POST update" do
    context "with valid input" do
      let(:queue_item_1) { Fabricate(:queue_item, user: current_user, position: 1) }
      let(:queue_item_2) { Fabricate(:queue_item, user: current_user, position: 2) }
      before { set_current_user }

      it "redirect to my_queue page" do
        post :update, queue_items: [{id: queue_item_1.id, position: 2}, {id: queue_item_2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders queue items" do
        post :update, queue_items: [{id: queue_item_1.id, position: 2}, {id: queue_item_2.id, position: 1}]
        expect(current_user.queue_items).to eq([queue_item_2, queue_item_1])
      end

      it "normalizes position numbers" do
        post :update, queue_items: [{id: queue_item_1.id, position: 3}, {id: queue_item_2.id, position: 2}]
        expect(queue_item_1.reload.position).to eq(2)
        expect(queue_item_2.reload.position).to eq(1)
      end

    end

    context "with invalid input" do
      let(:queue_item_1) { Fabricate(:queue_item, user: current_user, position: 1) }
      let(:queue_item_2) { Fabricate(:queue_item, user: current_user, position: 2) }
      before { set_current_user }

      it "redirects back to my_queue_page" do
        post :update, queue_items: [{id: queue_item_1.id, position: "asd"}, {id: queue_item_2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "sets flash error message" do
        post :update, queue_items: [{id: queue_item_1.id, position: "asd"}, {id: queue_item_2.id, position: 1}]
        expect(flash[:danger]).to be_present
      end

      it "does not change queue items" do
        post :update, queue_items: [{id: queue_item_1.id, position: 3}, {id: queue_item_2.id, position: "asd"}]
        expect(queue_item_1.reload.position).to eq(1)
        expect(queue_item_2.reload.position).to eq(2)
      end
    end

    context "cannot update queue item that is not of the current user" do
      it "does not change queue items" do
        set_current_user
        user_2 = Fabricate(:user)
        user_2_item_1 = Fabricate(:queue_item, user: user_2, position: 1)
        user_2_item_2 = Fabricate(:queue_item, user: user_2, position: 2)
        queue_item_1 = Fabricate(:queue_item, user: current_user, position: 1)
        post :update, queue_items: [{id: queue_item_1.id, position: 2}, {id: user_2_item_1.id, position: 3}]
        expect(user_2_item_1.reload.position).to eq(1)
      end
    end

    it_behaves_like "require sign in" do
      let(:action) { post :update, queue_items: [{id: 1, position: 1}, {id: 2, position: 1}] }
    end
  end
end
