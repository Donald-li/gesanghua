class DropOfflineDonors < ActiveRecord::Migration[5.1]
  def change
    drop_table :offline_donors
  end
end
