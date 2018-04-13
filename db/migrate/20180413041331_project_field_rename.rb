class ProjectFieldRename < ActiveRecord::Migration[5.1]
  def change
    change_table :projects do |t|
      t.rename :donate_record_amount_count, :total_amount # 项目累计捐款额统计字段改名

    end
  end
end
