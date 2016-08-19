class Gram < ActiveRecord::Base
  validates :message, presence: true
  validates :grampic, presence: true
  has_many :comments
  
  mount_uploader :grampic, GrampicUploader 

  belongs_to :user
end
