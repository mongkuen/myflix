class Followership < ActiveRecord::Base
  belongs_to :leader, class_name: "User"
  belongs_to :follower, class_name: "User"
end
