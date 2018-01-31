class AddTwoColumnsToFeedbacks < ActiveRecord::Migration[5.1]
  def change
    add_column :feedbacks, :check, :integer, comment: '查看 1: 未查看 2: 已查看'
    add_column :feedbacks, :recommend, :integer, comment: '推荐 1: 正常 2: 推荐'
  end
end
