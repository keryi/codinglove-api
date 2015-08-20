class Post < ActiveRecord::Base
  validates :ref_id, presence: true, uniqueness: true
end
