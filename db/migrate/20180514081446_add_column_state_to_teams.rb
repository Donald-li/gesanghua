class AddColumnStateToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :state, :integer
  end
end
