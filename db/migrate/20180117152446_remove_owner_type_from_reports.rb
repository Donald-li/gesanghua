class RemoveOwnerTypeFromReports < ActiveRecord::Migration[5.1]
  def change
    remove_column :reports, :owner_type, :string
    remove_column :reports, :owner_id, :integer
  end
end
