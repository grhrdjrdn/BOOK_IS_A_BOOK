class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :title
      t.string :authors
      t.text :description
      t.boolean :available, default: true

      t.timestamps
    end
  end
end
