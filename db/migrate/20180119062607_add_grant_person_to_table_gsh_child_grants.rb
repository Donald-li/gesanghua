class AddGrantPersonToTableGshChildGrants < ActiveRecord::Migration[5.1]
  def change
    add_column :gsh_child_grants, :grant_person, :string, comment: '发放人'
  end
end
