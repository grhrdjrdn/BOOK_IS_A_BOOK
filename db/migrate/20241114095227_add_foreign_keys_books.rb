class AddForeignKeysBooks < ActiveRecord::Migration[7.1]
  def change
    add_reference :histories, :book
    add_reference :requests, :book
  end
end
