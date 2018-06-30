# == Schema Information
#
# Table name: donate_records # 捐赠记录
#
#  id                            :integer          not null, primary key
#  donor_id                      :integer                                # 用户id
#  fund_id                       :integer                                # 基金ID
#  amount                        :decimal(14, 2)   default(0.0)          # 捐助金额
#  project_id                    :integer                                # 项目id
#  team_id                       :integer                                # 小组id
#  promoter_id                   :integer                                # 劝捐人
#  agent_id                      :integer                                # 汇款人id
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  project_season_id             :integer                                # 年度ID
#  project_season_apply_id       :integer                                # 年度项目ID
#  gsh_child_id                  :integer                                # 格桑花孩子id
#  income_record_id              :integer                                # 收入记录
#  title                         :string                                 # 捐赠标题
#  source_type                   :string
#  source_id                     :integer                                # 资金来源
#  owner_type                    :string
#  owner_id                      :integer                                # 捐助所属捐助项
#  donation_id                   :integer                                # 捐助id
#  kind                          :integer                                # 捐助方式 1:捐款 2:配捐
#  project_season_apply_child_id :integer                                # 一对一孩子
#  state                         :integer                                # 状态
#  school_id                     :integer                                # 学校id
#  archive_data                  :jsonb                                  # 归档旧数据
#

# 捐助记录
class DonateRecord < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :donor, class_name: 'User', foreign_key: 'donor_id', optional: true
  belongs_to :agent, class_name: 'User', foreign_key: 'agent_id', optional: true
  belongs_to :promoter, class_name: 'User', foreign_key: 'promoter_id', optional: true
  belongs_to :fund, optional: true
  belongs_to :project, optional: true
  belongs_to :season, class_name: 'ProjectSeason', foreign_key: 'project_season_id', optional: true
  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: 'project_season_apply_id', optional: true
  belongs_to :child, class_name: 'ProjectSeasonApplyChild', foreign_key: 'project_season_apply_child_id', optional: true
  # belongs_to :bookshelf, class_name: 'ProjectSeasonApplyBookshelf', foreign_key: 'project_season_apply_bookshelf_id', optional: true
  # belongs_to :supplement, class_name: 'BookshelfSupplement', foreign_key: 'bookshelf_supplement_id', optional: true
  belongs_to :team, optional: true
  belongs_to :income_record, optional: true
  belongs_to :gsh_child, class_name: 'GshChild', optional: true
  belongs_to :school, optional: true

  has_one :account_records

  counter_culture :project, column_name: :total_amount, delta_column: 'amount'
  counter_culture :team, column_name: :total_donate_amount, delta_column: 'amount'
  counter_culture :promoter, column_name: :promoter_amount_count, delta_column: 'amount'
  counter_culture :school, column_name: :total_amount, delta_column: 'amount'

  belongs_to :source, polymorphic: true
  belongs_to :owner, polymorphic: true

  validates :amount, presence: true

  enum state: {normal: 1, refund: 2} # 状态: 1:正常 2:退款
  default_value_for :state, 1

  enum kind: {user_donate: 1, platform_donate: 2} # 记录类型: 1:用户捐款 2:平台配捐
  default_value_for :kind, 1

  default_value_for :archive_data, {}

  scope :sorted, -> {order(created_at: :desc)}
  scope :visible, -> {normal}

  before_create :set_assoc_attrs

  def project_name
    self.project.try(:name) || '格桑花'
  end

  def donor_name
    self.donor.try(:name) || self.user.try(:user_name)
  end

  def donate_no
    self.income_record.try(:donation).try(:order_no)
  end

  # 代捐人名称
  def agent_name
    return '无' if self.agent.blank?
    self.agent_id == self.donor_id ? '无' : self.agent.try(:show_name)
  end

  def link_url
    if self.owner_type == 'DonateItem'
      "#{Settings.root_url}donates/new"
    elsif self.owner_type == 'ProjectSeasonApply'
      "#{Settings.root_url}goods/#{self.owner_id}/detail"
    elsif self.owner_type == 'ProjectSeasonApplyChild'
      "#{Settings.root_url}pairs/#{self.owner_id}/detail"
    elsif self.owner_type == 'ProjectSeasonApplyBookshelf'
      "#{Settings.root_url}reads/#{self.owner.try(:apply).try(:id)}/detail"
    elsif self.owner_type == 'GshChildGrant'
      "#{Settings.root_url}pairs/#{self.owner.try(:apply_child).try(:id)}/detail"
    elsif self.owner_type == 'CampaignEnlist'
      "#{Settings.root_url}campaigns/#{self.owner.campaign_id}"
    end
  end

  # 平台配捐
  # grant_number, donate_way(income_record, fund, user_balance), offline_record_id, fund_id, user_id
  def self.platform_donate(owner, amount, params)
    source = nil
    case params[:donate_way]
      when 'income_record'
        source = IncomeRecord.offline.find(params[:offline_record_id])
        donor = source.donor
        agent = source.agent
      when 'fund'
        source = Fund.find(params[:fund_id])
        donor = User.find(params[:donor_id])
      when 'user_balance'
        source = User.find(params[:user_id])
        donor = source
        agent = donor.enable? ? donor : (donor.manager || donor)
    end

    # donor = source.is_a?(User) ? source : params[:current_user]
    donor ||= params[:current_user]
    agent ||= donor

    result, message = self.do_donate(:platform_donate, source, owner, amount, donor: donor, agent: agent, operator: params[:current_user])
    return result
  end

  # 处理捐款
  # kind: 用户捐款、平台配捐；source：资金来源； owner：捐助对象；amount：捐助金额, ** agent, donor
  def self.do_donate(kind, source, owner, amount, **params)
    message = ''
    result = false
    income_record_id = source.instance_of?(IncomeRecord) ? source.id : nil
    donation_id = source.instance_of?(IncomeRecord) ? source.donation_id : nil

    amount = amount.to_f.round(2)

    self.transaction do # 事务
      # 来源金额是否充足？
      if source.balance.to_f < amount
        return false, '余额不足'
      else
        source.lock! # 加锁
      end
      donate_records = []

      if owner.class.name == 'GshChildGrant'
        school = owner.apply_child.school
      elsif owner.class.name == 'ProjectSeasonApplyBookshelf'
        school = owner.apply.school
      elsif owner.class.name == 'ProjectSeasonApply'
        school = owner.school
      elsif owner.class.name == 'ProjectSeasonApplyChild'
        school = owner.school
      else
        school = nil
      end

      # 如果捐到申请子项 （书架，孩子，指定）和具体的捐助项
      if owner.class.name.in?(['DonateItem', 'CampaignEnlist', 'GshChildGrant', 'ProjectSeasonApplyBookshelf'])
        donate_records << self.create!(source: source, kind: kind, owner: owner, amount: amount, income_record_id: income_record_id, donation_id: donation_id, agent: params[:agent], donor: params[:donor], team_id: params[:team_id], promoter_id: params[:promoter_id], school: school)
        owner.accept_donate(donate_records)

        # 如果是捐到申请（物资类项目，子项）
      elsif owner.class.name.in?(['ProjectSeasonApply', 'ProjectSeasonApplyChild'])
        # 物资或拓展营
        if owner.project.goods? || owner.project == Project.camp_project
          donate_records << self.create!(source: source, kind: kind, owner: owner, amount: amount, income_record_id: income_record_id, donation_id: donation_id, agent: params[:agent], donor: params[:donor], team_id: params[:team_id], promoter_id: params[:promoter_id], school: school)
          owner.accept_donate(donate_records)
        else
          # 如果是捐到申请（书架孩子，没选择子项）
          # 分解到子项，捐助到子项

          if owner.is_a?(ProjectSeasonApplyChild)
            owner.get_donate_items.each do |item|
              remain_amount = amount - donate_records.sum {|r| r.amount}
              if remain_amount >= item.surplus_money
                donate_records << self.create!(source: source, kind: kind, owner: item, amount: item.surplus_money, income_record_id: income_record_id, donation_id: donation_id, agent: params[:agent], donor: params[:donor], team_id: params[:team_id], promoter_id: params[:promoter_id], school: school)
                item.accept_donate(donate_records)
              end
            end
          else
            owner.get_donate_items.each do |item|
              remain_amount = amount - donate_records.sum {|r| r.amount}
              if remain_amount > 0
                donate_amount = [item.surplus_money, remain_amount].min
                donate_records << self.create!(source: source, kind: kind, owner: item, amount: donate_amount, income_record_id: income_record_id, donation_id: donation_id, agent: params[:agent], donor: params[:donor], team_id: params[:team_id], promoter_id: params[:promoter_id], school: school)
                item.accept_donate(donate_records)
              end
            end
          end

        end
      end

      donate_amount = donate_records.sum {|r| r.amount}

      reback = amount.to_f - donate_amount
      if reback > 0
        # 判断是否超捐，超捐退回余额，并扣除income_record balance
        if kind.to_s == 'user_donate' && source.is_a?(IncomeRecord) # 在线支付
          source.balance -= reback
          user = source.donor
          user.lock!
          AccountRecord.create!(title: self.apply_name + '超捐退款', kind: 'refund', amount: reback, income_record: source, user: source.agent, donor: source.donor, operator: operator.present? ? operator.try(:id) : self.agent_id)
          user.save!
          message = "捐助成功，但捐助过程中，项目收到新捐款造成超捐，其中#{reback}元已退回您的账户余额。"
        else
          result = false
          message = '捐助失败，捐助项收到新捐款造成超捐.'
          raise ActiveRecord::Rollback, "超捐"
        end
      end

      # 记录余额消耗记录
      if source.is_a?(User)
        AccountRecord.create!(title: '使用余额捐助' + self.apply_name, kind: 'donate', amount: 0 - amount, user: source, donor: params[:donor], operator: operator.present? ? operator.try(:id) : self.agent_id)
      elsif source.is_a?(IncomeRecord)
        source.balance -= donate_amount
      end
      source.save! # 解锁

      result = true
      message = '捐助成功'
    end
    return result, message
  end

  # 计算开票金额
  def self.count_amount(ids)
    donates = DonateRecord.find(ids)
    if donates.present?
      amount = donates.sum {|d| d.amount.to_f}
      return amount
    else
      return 0
    end
  end

  # 只有格桑花孩子可以退款
  def can_refund?
    (self.user_donate? || ['IncomeRecord', 'User'].include?(self.source_type)) && self.agent.present? && self.owner_type == 'GshChildGrant' && (self.owner.waiting? || self.owner.suspend?)
  end

  # 退款, 捐助记录退款状态，退回账户余额，孩子标记取消
  def do_refund!(operator)
    return false unless self.can_refund?
    self.transaction do
      # 退余额
      self.agent.lock!
      AccountRecord.create!(title: self.apply_name + '退款', kind: 'refund', amount: self.amount, donate_record: self, user: self.agent, donor: self.donor, operator_id: operator.try(:id))
      self.agent.save!

      self.refund!
      self.owner.cancel!
      self.owner.refund!
    end
    # TODO: 通知
    return true
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :project_id, :project_season_apply_id, :project_season_apply_child_id)
      json.project_alias self.project.try(:alias)
      json.donor self.donor.try(:show_name)
      json.project_name self.project.try(:name)
      json.apply_name self.apply_name
      json.apply_image self.apply_image
      json.time self.created_at
      json.amount amount
      json.donate_tag self.donor_id === self.agent_id ? '' : '代捐'
      json.project_id
      json.user_name self.donor.try(:show_name) || '爱心人士'
      json.user_avatar self.donor.try(:user_avatar)
    end.attributes!
  end

  def apply_image
    apply_image = case self.owner_type
                    when 'DonateItem'
                      self.owner.project.try(:image_url, :tiny)
                    when 'ProjectSeasonApply'
                      self.owner.cover_image_url(:tiny)
                    when 'GshChildGrant' # 优先展示发放照片
                      self.owner.images.first.try(:file).try(:url, :tiny) || self.child.try(:avatar_url, :tiny)
                    when 'ProjectSeasonApplyChild'
                      self.owner.project.try(:image_url, :tiny)
                    when 'ProjectSeasonApplyBookshelf', 'BookshelfSupplement'
                      self.owner.apply.try(:cover_image_url, :tiny)
                    when 'CampaignEnlist'
                      self.owner.try(:campaign).try(:image_url, :tiny)
                  end
    apply_image
  end

  def apply_name
    apply_name = if self.owner_type == 'DonateItem' || self.owner_type == 'ProjectSeasonApply'
                   self.owner.name
                 elsif self.owner_type == 'GshChildGrant'
                   self.child.try(:name).to_s + ' · ' + self.owner.try(:title).to_s
                 elsif self.owner_type == 'ProjectSeasonApplyChild'
                   self.owner.try(:name)
                 elsif self.owner_type == 'ProjectSeasonApplyBookshelf'
                   self.owner.apply.try(:name)
                 elsif self.owner_type == 'BookshelfSupplement'
                   self.owner.apply.try(:name)
                 elsif self.owner_type == 'CampaignEnlist'
                   self.owner.try(:campaign).try(:name)
                 end
    apply_name
  end

  def apply_surplus_money
    return false if self.owner_type == 'DonateItem' || self.owner_type == 'GshChildGrant' || self.owner_type == 'ProjectSeasonApplyChild' || self.owner_type == 'CampaignEnlist'
    apply_surplus_money = if self.owner_type == 'ProjectSeasonApply'
                            self.owner.surplus_money
                          elsif self.owner_type == 'ProjectSeasonApplyBookshelf' || self.owner_type == 'BookshelfSupplement'
                            self.owner.apply.try(:surplus_money)
                          end
    apply_surplus_money
  end

  def show_apply_name
    return unless self.owner.present?
    show_apply_name = if self.owner_type == 'DonateItem' || self.owner_type == 'ProjectSeasonApply'
                        self.owner.name
                      elsif self.owner_type == 'GshChildGrant'
                        self.child.try(:secure_name) + ' · ' + self.owner.try(:title).to_s
                      elsif self.owner_type == 'ProjectSeasonApplyChild'
                        self.owner.try(:secure_name)
                      elsif self.owner_type == 'ProjectSeasonApplyBookshelf'
                        self.owner.apply.try(:name)
                      elsif self.owner_type == 'BookshelfSupplement'
                        self.owner.apply.try(:name)
                      elsif self.owner_type == 'CampaignEnlist'
                        self.owner.campaign.try(:name)
                      end
    show_apply_name
  end

  #
  # def donate_project
  #   if self.owner_type == 'DonateItem' || self.owner_type == 'ProjectSeasonApply'
  #     self.owner.try(:name)
  #   elsif self.owner_type == 'ProjectSeasonApplyChild'
  #     self.owner.try(:project).try(:name) + self.owner.secure_name
  #   elsif self.owner_type == 'ProjectSeasonApplyBookshelf'
  #     self.owner.try(:apply).try(:name) + self.owner.classname
  #   elsif self.owner_type == 'CampaignEnlist'
  #     self.owner.try(:campaign).try(:name)
  #   end
  # end

  def view_project_detail_path_name
    if self.owner_type == 'ProjectSeasonApply'
      if self.owner.project == Project.read_project
        if self.owner.whole?
          'read'
        elsif self.owner.supplement?
          'read-supplement'
        end
      elsif self.owner.project == Project.camp_project
        'camp'
      else
        'goods'
      end
    elsif self.owner_type == 'ProjectSeasonApplyBookshelf'
      'read'
    elsif self.owner_type == 'DonateItem'
      'donation'
    elsif self.owner_type == 'ProjectSeasonApplyChild'
      'pair'
    elsif self.owner_type == 'CampaignEnlist'
      'campaign'
    end
  end

  def view_project_detail_path_params
    if self.owner_type == 'ProjectSeasonApply'
      if self.owner.project == Project.read_project
        self.owner_id
      end
    elsif self.owner_type == 'ProjectSeasonApplyBookshelf'
      self.owner.apply.id
    elsif self.owner_type == 'DonateItem'
      self.owner.project
    elsif self.owner_type == 'ProjectSeasonApplyChild'
      self.owner_id
    elsif self.owner_type == 'CampaignEnlist'
      self.owner.campaign.id
    end
  end

  private

  # 补充捐助记录信息
  def get_donate_record_info
    self.project = self.owner.project if self.owner.project.present?
    self.season = self.owner.season if self.owner.season.present?
    self.apply = self.owner.apply if self.owner.apply.present?
    self.child = self.owner.child if self.owner.child.present?
    self.donation = self.source.donation if self.owner.is_a?('IncomeRecord') && self.source.donation.present?
  end

  def set_assoc_attrs
    income_record = self.income_record
    self.team_id ||= income_record.try(:team_id)
    self.promoter_id ||= income_record.try(:promoter_id)

    case self.owner
      when GshChildGrant
        self.project_season_apply_child_id = self.owner.project_season_apply_child_id
        self.project_season_apply_id = self.owner.project_season_apply_id
        self.project_season_id = self.apply.try(:project_season_id)
        self.project_id = Project.pair_project.id
      when ProjectSeasonApplyChild, ProjectSeasonApplyBookshelf
        self.project_id = self.owner.project_id
        self.project_season_id = self.owner.project_season_id
        self.project_season_apply_id = self.owner.project_season_apply_id
      when ProjectSeasonApply
        self.project_id = self.owner.project_id
        self.project_season_id = self.owner.project_season_id
        self.project_season_apply_id = self.owner_id
      when BookshelfSupplement
        self.project_id = self.owner.project_id
        self.project_season_apply_id = self.owner.try(:project_season_apply_id)
      when DonateItem
        self.project_id = self.owner.project.try(:id)
    end
  end

end
