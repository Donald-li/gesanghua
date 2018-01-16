class CreateProjectSeasons < ActiveRecord::Migration[5.1]
  def change
    create_table :project_seasons, comment: '项目执行年度表' do |t|
      t.integer :project_id, comment: '关联项目表id'
      t.string :name, comment: '执行年度名称'
      t.integer :state, comment: '状态 1:未执行 2:执行中'
      t.decimal :junior_term_amount, precision: 14, scale: 2, default: '0.0', comment: '初中资助金额（学期）'
      t.decimal :junior_year_amount, precision: 14, scale: 2, default: '0.0', comment: '初中资助金额（学年）'
      t.decimal :senior_term_amount, precision: 14, scale: 2, default: '0.0', comment: '高中资助金额（学期）'
      t.decimal :senior_year_amount, precision: 14, scale: 2, default: '0.0', comment: '高中资助金额（学年）'

      t.timestamps
    end
  end
end
