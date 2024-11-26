class Category < ApplicationRecord
  # Associations
  has_many :categorized_products, dependent: :destroy
  has_many :products, through: :categorized_products

  # Validations
  validates :name, presence: true, uniqueness: true

  # implement a nested category structure with the `ancestry` gem
  # has_ancestry
end