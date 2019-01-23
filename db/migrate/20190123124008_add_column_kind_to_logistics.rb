class AddColumnKindToLogistics < ActiveRecord::Migration[5.1]
  def change
    add_column :logistics, :kind, :integer
  end
end
