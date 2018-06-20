class AddColumnRemarkToVolunteer < ActiveRecord::Migration[5.1]
  def change
    add_column :volunteers, :remark, :text
  end
end
