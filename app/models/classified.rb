class Classified < ApplicationRecord
  belongs_to :user

  # validates :user, presence: true
  # or
  validates_presence_of :user
end
