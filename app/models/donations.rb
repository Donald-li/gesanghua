# == Schema Information
#
# Table name: donations # 捐助表
#
#  id                      :integer          not null, primary key
#  donor_id                :integer                                # 捐助人id
#  owner_type              :string
#  owner_id                :integer                                # 捐助所属模型
#  pay_state               :integer                                # 支付状态
#  voucher_state           :integer                                # 捐赠收据状态
#  project_id              :integer                                # 项目id
#  project_season_id       :integer                                # 批次/年度id
#  project_season_apply_id :integer                                # 申请id
#  order_no                :string                                 # 订单编号
#  certificate_no          :string                                 # 捐赠证书编号
#  title                   :string                                 # 标题
#  promoter_id             :integer                                # 劝捐人
#  team_id                 :integer                                # 团队id
#  pay_result              :text                                   # 支付接口返回的支付接口数据
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  details                 :jsonb                                  # 捐助详情
#

# 捐助
class Donations < ApplicationRecord

  has_many :income_records
  belongs_to :donor, class_name: 'User', foreign_key: 'donor_id', optional: true
  belongs_to :agent, class_name: 'User', foreign_key: 'agent_id', optional: true
  belongs_to :promoter, class_name: 'User', foreign_key: 'promoter_id', optional: true
  belongs_to :team, optional: true
  belongs_to :project, class_name: 'Project', optional: true
  belongs_to :season, class_name: 'ProjectSeason', optional: true
  belongs_to :apply, class_name: 'ProjectSeasonApply', optional: true

  before_create :set_record_title
  before_create :generate_donate_no


  private
  def set_record_title
    return if self.title.present?
    if self.donate_item.present?
      self.title = "#{self.try(:donor).try(:name)}捐助#{self.try(:donate_item).try(:name)}#{self.try(:donate_item).try(:fund).try(:name)}款项"
    else
      self.title = "#{self.try(:donor).try(:name)}捐助#{self.try(:apply).try(:apply_name)}#{self.try(:child).try(:name)}#{self.try(:bookshelf).try(:show_title)}款项"
    end
  end

  def generate_donate_no
    time_string = Time.now.strftime("%y%m%d%H")
    self.donate_no ||= Sequence.get_seq(kind: :order_no, prefix: time_string, length: 7)
  end

end
