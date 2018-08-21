class AddColumnUrlToFeedbacks < ActiveRecord::Migration[5.1]
  def change
    add_column :gsh_child_grants, :url, :string, comment: '发放报告链接'
  end
end
