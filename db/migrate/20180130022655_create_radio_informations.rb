class CreateRadioInformations < ActiveRecord::Migration[5.1]
  def change
    create_table :radio_informations, comment: '广播详细信息表' do |t|
      t.integer :student_number, default: 0, comment: '学生总数'
      t.integer :boarder_number, default: 0, comment: '住宿总数'
      t.integer :dormitory_number, default: 0, comment: '宿舍楼总数'
      t.integer :dorm_number, default: 0, comment: '宿舍总数'
      t.integer :first_grade, default: 0, comment: '一年级'
      t.integer :second_grade, default: 0, comment: '二年级'
      t.integer :third_grade, default: 0, comment: '三年级'
      t.integer :fourth_grade, default: 0, comment: '四年级'
      t.integer :fifth_grade, default: 0, comment: '五年级'
      t.integer :sixth_grade, default: 0, comment: '六年级'
      t.integer :project_season_apply_id, comment: '申请id'

      t.timestamps
    end
  end
end
