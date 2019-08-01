class BatchNoticeJob < ApplicationJob
  queue_as :default

  def perform(ids: nil, content: nil, current_user: nil)
    total = ids.length
    current = 0

    ids.each do |id|
      user = User.find(id)
      Notification.create(
          kind: 'new_notice',
          owner: user,
          user_id: id,
          title: '消息提醒',
          content: content
      )

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
