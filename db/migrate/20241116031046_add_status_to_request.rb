class AddStatusToRequest < ActiveRecord::Migration[7.1]
  def change
    add_column :requests, :status, :integer
    remove_column :requests, :approved, :boolean
  end
end
