class Chat < ActiveRecord::Base
  validates :user, presence: true
  validates :message, presence: true, length: { maximum: 140 }
end
