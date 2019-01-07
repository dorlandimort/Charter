class AddReverseToData < ActiveRecord::Migration[5.1]
  def change
    add_column :data, :reverse, :boolean, default: false
  end
end
