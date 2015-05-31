module Tokenable
  extend ActiveSupport::Concern

  def save_token
    self.token = SecureRandom.urlsafe_base64
    self.save
  end
end
