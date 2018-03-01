class RecreateGshChildren < ActiveRecord::Migration[5.1]
  def change
    create_table :gsh_children, comment: '格桑花孩子表' do |t|
      t.string :name, comment: '孩子姓名'
      t.integer :kind, :integer, comment: '类型'
      t.string :workstation, comment: '工作地点'
      t.string :name, comment: "孩子姓名"
      t.string :province, comment: "省"
      t.string :city, comment: "市"
      t.string :district, comment: "区/县"
      t.string :gsh_no, comment: "格桑花孩子编号"
      t.string :phone, comment: "联系电话"
      t.string :qq, comment: "qq号"
      t.integer :user_id, comment: "关联用户id"
      t.string :id_card, comment: "身份证"
      t.integer :semester_count, default: 0, comment: "孩子申请学期总数"
      t.integer :done_semester_count, default: 0, comment: "孩子募款成功学期总数"

      t.timestamps
    end
    rename_column :teachers, :idcard, :id_card
    rename_column :users, :idcard, :id_card
    rename_column :schools, :contact_idcard, :contact_id_card
  end
end
