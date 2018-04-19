class CreateGshChildGrants < ActiveRecord::Migration[5.1]
  def change
    drop_table :child_grants, comment: '删除旧孩子发放表'

    create_table :gsh_child_grants, comment: '格桑花孩子发放表' do |t|

      t.belongs_to :gsh_child, comment: '关联孩子表id'
      t.belongs_to :project_season_apply, comment: '关联申请表'
      t.integer :state, comment: '状态 1:为筹款 2:待发放 3:发放完成'
      t.decimal :amount, precision: 14, scale: 2, default: 0.0, comment: '发放金额'

      t.timestamps
    end
  end
end
