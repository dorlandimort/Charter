class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string :header, null: false
      t.integer :order
      t.decimal :value
      t.belongs_to :datum
    end
  end
end
