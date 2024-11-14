class AddForeignKeyToRequests < ActiveRecord::Migration[7.1]
  def change
    add_reference :requests, :user
  end
end
