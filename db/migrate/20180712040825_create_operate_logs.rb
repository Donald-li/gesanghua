class CreateOperateLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :operate_logs do |t|
      t.integer :user_id
      t.string :title

      t.timestamps
    end
  end
end
