class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :gram

  validates :message, presence: true
end
