# == Schema Information
#
# Table name: feedbacks # 反馈表
#
#  id            :integer          not null, primary key
#  content       :text                                   # 内容
#  owner_type    :string
#  owner_id      :integer
#  type          :string                                 # 类型：receive、install、continual
#  state         :integer                                # 状态
#  approve_state :integer                                # 审核状态
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  kind          :integer                                # 反馈类型
#  check         :integer                                # 查看 1: 未查看 2: 已查看
#  recommend     :integer                                # 推荐 1: 正常 2: 推荐
#  user_id       :integer                                # 反馈人
#

class Continual < Feedback
end
