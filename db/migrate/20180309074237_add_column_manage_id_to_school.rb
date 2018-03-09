class AddColumnManageIdToSchool < ActiveRecord::Migration[5.1]
  def change
    add_column :schools, :creater_id, :integer, comment: '申请人ID'
  end
end
