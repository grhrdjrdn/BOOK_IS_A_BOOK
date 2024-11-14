class CreateRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :requests do |t|
      t.boolean :approved

      t.timestamps
    end
  end
end
