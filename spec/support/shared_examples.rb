shared_examples "require sign in" do
  it "redirects to root path" do
    clear_session
    action
    expect(flash[:danger]).to be_present
    expect(response).to redirect_to root_path
  end
end

shared_examples "require admin" do
  it "redirects to root path" do
    clear_session
    set_current_user
    action
    expect(flash[:danger]).to be_present
    expect(response).to redirect_to root_path
  end
end

shared_examples "redirects if authenticated" do
  it "redirects to home_path" do
    set_current_user
    action
    expect(response).to redirect_to home_path
  end
end

shared_examples "tokenable" do
  it "generates and saves token to an object" do
    model = object
    model.generate_token
    expect(model.class.first.token).to be_present
  end
end
