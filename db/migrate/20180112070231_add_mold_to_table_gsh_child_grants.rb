class AddMoldToTableGshChildGrants < ActiveRecord::Migration[5.1]
  def change
    add_column :feedbacks, :kind, :integer, comment: '反馈类型'
  end
end
