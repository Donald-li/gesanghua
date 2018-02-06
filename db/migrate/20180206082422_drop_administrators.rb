class DropAdministrators < ActiveRecord::Migration[5.1]
  def change
    drop_table :administrators
  end
end
