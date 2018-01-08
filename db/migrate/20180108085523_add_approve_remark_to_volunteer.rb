class AddApproveRemarkToVolunteer < ActiveRecord::Migration[5.1]
  def change
    add_column :volunteers, :approve_remark, :text, comment: '审核备注'
  end
end
