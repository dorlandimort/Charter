class CreateData < ActiveRecord::Migration[5.1]
  def change
    create_table :data do |t|
      t.string :name, null: false
      t.string :file, null: false
      t.integer :columns
      t.integer :rows
      t.integer :group_column
      t.integer :count_column
    end
  end
end
