class Gram < ActiveRecord::Base
  validates :message, presence: true
  validates :grampic, presence: true

  mount_uploader :grampic, GrampicUploader 

  belongs_to :user
  has_many :comments
end
