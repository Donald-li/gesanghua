class CreateTaskCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :task_categories, comment: '任务分类' do |t|
      t.string :name, comment: '分类名称'
      t.text :describe, comment: '分类描述'

      t.timestamps
    end
  end
end
