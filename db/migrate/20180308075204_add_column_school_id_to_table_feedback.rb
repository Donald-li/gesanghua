class AddColumnSchoolIdToTableFeedback < ActiveRecord::Migration[5.1]
  def change
    add_column :feedbacks, :school_id, :integer, comment: '学校id'
  end
end
