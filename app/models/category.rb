class Category < ApplicationRecord
  has_ancestry
  has_many :books

  validates :name, presence: true
end
