class AddForeignKeyHistoryToRequests < ActiveRecord::Migration[7.1]
  def change
    add_reference :requests, :history
  end
end
