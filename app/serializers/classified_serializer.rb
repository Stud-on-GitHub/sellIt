class ClassifiedSerializer < ActiveModel::Serializer
  attributes :id, :title, :price, :description, :category
  belongs_to :user
end
