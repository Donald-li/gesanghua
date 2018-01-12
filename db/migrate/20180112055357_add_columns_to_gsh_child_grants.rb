class AddColumnsToGshChildGrants < ActiveRecord::Migration[5.1]
  def change
    add_column :gsh_child_grants, :title, :string, comment: '标题'
  end
end
