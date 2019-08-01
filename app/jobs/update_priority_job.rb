class UpdatePriorityJob < ApplicationJob
  queue_as :default

  def perform(current_user: nil)
    children = ProjectSeasonApplyChild.pass.hidden.sorted
    total = children.count
    current = 0
    children.each do |child|
      child.update(priority_id: child.semesters.sorted.succeed.last.try(:user_id))
      if current % 10 == 0
        percentage = current / total.to_f
        ActionCable.server.broadcast "update_priority_#{current_user.id}", data: {percentage: (percentage * 100).to_i, message: '正在发送', total: total}
        puts "#current | #{percentage} | #{total} | #{(percentage * 100).to_i}"
      end
      current += 1
      if current == total
        ActionCable.server.broadcast "batch_notice_#{current_user.id}", data: {percentage: 100, message: '完成', total: total}
      end
    end
  end

end
