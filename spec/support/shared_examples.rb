shared_examples "require sign in" do
  it "redirects to root path" do
    clear_session
    action
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
