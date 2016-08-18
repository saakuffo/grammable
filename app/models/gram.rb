class Gram < ActiveRecord::Base
  belongs_to :user
  mount_uploader :grampic, GrampicUploader  
  validates :message, presence: true
end
