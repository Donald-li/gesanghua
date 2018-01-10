class AddKindToSchools < ActiveRecord::Migration[5.1]
  def change
    add_column :schools, :kind, :integer, comment: '学校类型'
  end
end
