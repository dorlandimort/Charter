class CreateHeaders < ActiveRecord::Migration[5.1]
  def change
    create_table :headers do |t|

      t.string :name
      t.belongs_to :datum
    end
  end
end
