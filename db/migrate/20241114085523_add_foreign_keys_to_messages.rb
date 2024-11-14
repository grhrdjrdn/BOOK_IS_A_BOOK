class AddForeignKeysToMessages < ActiveRecord::Migration[7.1]
  def change
    add_reference :messages, :user
    add_reference :messages, :request
  end
end
