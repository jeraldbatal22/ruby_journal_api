class Category < ApplicationRecord
  belongs_to :user
  has_many :tasks
  validates :name, :description, presence: true
end
