class AddSomeColumnToVolunteer < ActiveRecord::Migration[5.1]
  def change
    add_column :volunteers, :gender, :integer, comment: '性别'
    add_column :volunteers, :source, :string, comment: '获知渠道'
    add_column :volunteers, :experience, :text, comment: '志愿者经历'
  end
end
