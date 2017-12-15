class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams, comment: '小组' do |t|
      t.string :name, comment: '名称'
      t.integer :member_count, comment: '会员数'
      t.decimal :current_donate_amount, precision: 14, scale: 2, default: "0.0", comment: '当前捐助金额'
      t.decimal :total_donate_amount, precision: 14, scale: 2, default: "0.0", comment: '捐助总额'
      t.integer :creater_id, comment: '团队创建人id'

      t.timestamps
    end
  end
end
