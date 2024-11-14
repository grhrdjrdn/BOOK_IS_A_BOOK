class AddFieldsToHistory < ActiveRecord::Migration[7.1]
  def change
    add_column :histories, :date_acquired, :datetime
    add_reference :histories, :user
  end
end
