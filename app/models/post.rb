class Post < ActiveRecord::Base
  validates :ref_id, presence: true, uniqueness: true
  acts_as_taggable
  has_many :imagga_tags
end
