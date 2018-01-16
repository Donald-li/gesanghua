class CreateProjectSeasonApplies < ActiveRecord::Migration[5.1]
  def change
    create_table :project_season_applies, comment: '项目执行年度申请表' do |t|
      t.integer :project_id, comment: '关联项目id'
      t.integer :project_season_id, comment: '关联项目执行年度的id'
      t.integer :school_id, comment: '关联学校id'
      t.integer :teacher_id, comment: '负责项目的老师id'
      t.text :describe, comment: '描述、申请要求'
      t.string :province, comment: '省'
      t.string :city, comment: '市'
      t.string :district, comment: '区/县'
      t.integer :state, comment: '状态：1:展示 2:隐藏', default: 1
      t.integer :gsh_child_id, comment: '关联格桑花孩子id'
      t.integer :gsh_bookshelf_id, comment: '关联格桑花书架(图书角)id'

      t.timestamps
    end
  end
end
