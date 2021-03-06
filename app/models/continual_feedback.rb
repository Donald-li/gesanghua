# == Schema Information
#
# Table name: feedbacks # 反馈表
#
#  id                                :bigint(8)        not null, primary key
#  content                           :text                                   # 内容
#  owner_type                        :string
#  owner_id                          :integer
#  type                              :string                                 # 类型：receive、install、continual
#  state                             :integer                                # 状态
#  approve_state                     :integer                                # 审核状态
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  kind                              :integer                                # 反馈类型
#  check                             :integer                                # 查看 1: 未查看 2: 已查看
#  recommend                         :integer                                # 推荐 1: 正常 2: 推荐
#  user_id                           :integer                                # 反馈人
#  project_id                        :integer                                # 项目id
#  project_season_id                 :integer                                # 批次id
#  project_season_apply_id           :integer                                # 申请id
#  project_season_apply_child_id     :integer                                # 孩子id
#  project_season_apply_bookshelf_id :integer                                # 书架id
#  class_name                        :string                                 # 反馈班级
#  gsh_child_grant_id                :integer                                # 学生某学期的持续反馈（感谢信）
#  school_id                         :integer                                # 学校id
#  arise_at                          :datetime                               # 开展时间
#  arise_class                       :string                                 # 开展班级
#  number                            :integer                                # 参与人数
#

# 持续反馈
class ContinualFeedback < Feedback
  scope :visible, ->{show}
end
