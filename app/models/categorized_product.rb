class CategorizedProduct < ApplicationRecord
  # Associations
  belongs_to :product
  belongs_to :category

  # Validations to prevent duplicate associations
  validates :product_id, uniqueness: { scope: :category_id }
end
