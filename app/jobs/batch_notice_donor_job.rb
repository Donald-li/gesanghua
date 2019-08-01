class BatchNoticeDonorJob < ApplicationJob
  queue_as :default

  def perform(current_user: nil)
    children = ProjectSeasonApplyChild.pass.hidden.sorted
    total = children.length
    current = 0
    children.each do |child|
      user_id = child.priority_id
      pending_grants = child.semesters.pending
      if pending_grants.count > 0 && pending_grants.first.try(:title).to_s.start_with?(Time.now.year.to_s) && user_id.present?
        Notification.create(
            kind: 'continue_donate',
            owner: child,
            user_id: user_id,
            title: "#续捐通知# 您有一个孩子待续捐",
            content: "您捐助过的#{child.name}新的学年助学款可以续捐了，请及时续捐",
            url: "#{Settings.m_root_url}/pair/#{child.id}"
        )
      end

      if current % 10 == 0
        percentage = current / total.to_f
        ActionCable.server.broadcast "batch_notice_#{current_user.id}", data: {percentage: (percentage * 100).to_i, message: '正在发送', total: total}
        puts "#current | #{percentage} | #{total} | #{(percentage * 100).to_i}"
      end
      current += 1
      if current == total
        ActionCable.server.broadcast "batch_notice_#{current_user.id}", data: {percentage: 100, message: '完成', total: total}
      end
    end

  end

end
