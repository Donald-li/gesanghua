class AddSchoolIdToDonateRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :donate_records, :school_id, :integer, comment: '学校id'
    add_column :schools, :total_amount, :integer, comment: '累计获捐'
  end
end
