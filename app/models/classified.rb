class Classified < ApplicationRecord
  belongs_to :user

  # validates :user, presence: true
  # or
  validates_presence_of :user, :title, :price, :description
  validates_numericality_of :price
end
