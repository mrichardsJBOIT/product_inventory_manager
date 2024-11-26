class CreateCategorizedProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :categorized_products do |t|
      t.references :product, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
