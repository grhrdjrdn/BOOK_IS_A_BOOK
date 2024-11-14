class DropFlats < ActiveRecord::Migration[7.1]
  def change
    drop_table :flats
  end
end
