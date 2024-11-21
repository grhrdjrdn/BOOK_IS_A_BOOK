class AddDefaultToStatus < ActiveRecord::Migration[7.1]
  def change
    change_column_default :requests, :status, 0
  end
end
