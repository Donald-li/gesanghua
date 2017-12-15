class CreateMajors < ActiveRecord::Migration[5.1]
  def change
    create_table :majors, comment: '专业表' do |t|
      t.string :name, comment: '专业名称'

      t.timestamps
    end
  end
end
