class CreateData < ActiveRecord::Migration[5.1]
  def change
    create_table :data do |t|
      t.string :name, null: false
      t.string :file
      t.integer :columns
      t.integer :rows
      t.integer :group_column
      t.json :header_columns, default: {columns: []}
    end
  end
end
