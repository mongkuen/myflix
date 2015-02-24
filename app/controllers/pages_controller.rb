class PagesController < ApplicationController
  def passthrough
    if logged_in?
      redirect_to home_path
    else
      render :front
    end
  end

  def front
  end
end
