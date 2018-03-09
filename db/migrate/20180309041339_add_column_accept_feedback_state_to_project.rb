class AddColumnAcceptFeedbackStateToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :accept_feedback_state, :integer, comment: '是否接受定期反馈：1:open_feedback 2:close_feedback'
    add_column :projects, :feedback_period, :integer, comment: '建议定期反馈次数/年'
  end
end
