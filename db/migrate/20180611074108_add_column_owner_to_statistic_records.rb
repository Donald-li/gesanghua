class AddColumnOwnerToStatisticRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :statistic_records, :owner_type, :string
    add_column :statistic_records, :owner_id, :integer
  end
end
