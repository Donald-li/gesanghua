class ChangeDescirbeTypeForSchools < ActiveRecord::Migration[5.1]
  def change
    change_column :schools, :describe, :text, comment: '学校简介'
  end
end
