class ChangeColumnsToTasks < ActiveRecord::Migration[5.1]
  def change
    remove_column :tasks, :types_mask, :integer
    add_column :tasks, :ordinary_flag, :boolean, default: false, comment: '日常'
    add_column :tasks, :intensive_flag, :boolean, default: false, comment: '重点'
    add_column :tasks, :urgency_flag, :boolean, default: false, comment: '紧急'
    add_column :tasks, :innovative_flag, :boolean, default: false, comment: '创新'
    add_column :tasks, :difficult_flag, :boolean, default: false, comment: '难点'
  end
end
