class Product < ApplicationRecord
  # Associations
  has_many :categorized_products, dependent: :destroy
  has_many :categories, through: :categorized_products
  accepts_nested_attributes_for :categories
  before_validation :remove_duplicate_categories

  # Validations
  validates :name, presence: true
  validates :price, presence: true,
            numericality: { greater_than_or_equal_to: 0 }

  # Scopes for advanced querying
  scope :by_keyword, ->(keyword) {
    where("lower(name) LIKE :keyword OR
           lower(description) LIKE :keyword OR
           EXISTS (
             SELECT 1 FROM categorized_products cp
             JOIN categories c ON cp.category_id = c.id
             WHERE cp.product_id = products.id
             AND lower(c.name) LIKE :keyword
           )", keyword: "%#{keyword.downcase}%")
  }

  scope :created_between, ->(start_date, end_date) {
    where(created_at: start_date..end_date) if start_date.present? && end_date.present?
  }

  # Class method to find top categories
  def self.top_categories(limit = 5)
    Category.joins(:categorized_products)
            .group('categories.id')
            .select('categories.*, COUNT(categorized_products.product_id) as product_count')
            .order('product_count DESC')
            .limit(limit)
  end

  # Nested products retrieval by category
  def self.by_category_with_descendants(category)
    # Implementation using recursive CTE or nested set would be more efficient for deep category trees
    category_ids = [category.id] + category.descendants.pluck(:id)
    joins(:categories).where(categories: { id: category_ids }).distinct
  end

  def remove_duplicate_categories
    puts "CHECKNG FOR DUPLICATES"
    self.categories = self.categories.uniq  { |category| category.name }
    pp self.categories
  end
end