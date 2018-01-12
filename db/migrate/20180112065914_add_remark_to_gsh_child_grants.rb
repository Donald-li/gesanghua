class AddRemarkToGshChildGrants < ActiveRecord::Migration[5.1]
  def change
    add_column :gsh_child_grants, :remark, :text
  end
end
