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

  belongs_to :source, polymorphic: true
  belongs_to :owner, polymorphic: true

  validates :amount, presence: true

  enum kind: {user_donate: 1, platform_donate: 2} # 记录类型: 1:用户捐款 2:平台配捐
  default_value_for :kind, 1

  scope :sorted, -> {order(created_at: :desc)}

  before_create :set_assoc_attrs

  def project_name
    self.project.try(:name) || '格桑花'
  end

  def donate_item_name
    self.donate_item.try(:name)
  end

  def donor_name
    self.donor || self.user.user_name
  end

  # 处理捐款
  # kind: 用户捐款、平台配捐；source：资金来源； owner：捐助对象；amount：捐助金额
  def self.do_donate(kind, source, owner, amount, **params)
    result = false
    income_record_id = source.instance_of?(IncomeRecord) ? source.id : nil
    donation_id = source.instance_of?(IncomeRecord) ? source.donation_id : nil

    self.transaction do # 事务
      # 来源金额是否充足？
      if source.balance < amount.to_f
        return false
      else
        source.lock! # 加锁
      end
      donate_records = []

      #
      # # 如果是捐到捐助项
      # if owner.is_a?(DonateItem)
      #   donate_records << self.create!(source: source, kind: kind, owner: owner, amount: amount, income_record_id: income_record_id, donation_id: donation_id, agent: params[:agent], donor: params[:donor])
      #   owner.accept_donate(donate_records)
      #
      # # 活动报名
      # elsif owner.is_a?(CampaignEnlist)
      #   donate_records << self.create!(source: source, kind: kind, owner: owner, amount: amount, income_record_id: income_record_id, donation_id: donation_id, agent: params[:agent], donor: params[:donor])
      #   owner.accept_donate(donate_records)

      # 如果捐到申请子项 （书架，孩子，指定）和具体的捐助项
      if owner.class.name.in?(['DonateItem', 'CampaignEnlist', 'GshChildGrant', 'ProjectSeasonApplyBookshelf'])
        donate_records << self.create!(source: source, kind: kind, owner: owner, amount: amount, income_record_id: income_record_id, donation_id: donation_id, agent: params[:agent], donor: params[:donor])
        owner.accept_donate(donate_records)

      # 如果是捐到申请（物资类项目，子项）
      elsif owner.class.name.in?(['ProjectSeasonApply', 'ProjectSeasonApplyChild'])
        # 物资或拓展营
        if owner.project.goods? || owner.project == Project.camp_project
          donate_records << self.create!(source: source, kind: kind, owner: owner, amount: amount, income_record_id: income_record_id, donation_id: donation_id, agent: params[:agent], donor: params[:donor])
          owner.accept_donate(donate_records)
        else
          # 如果是捐到申请（书架孩子，没选择子项）
          # 分解到子项，捐助到子项

          if owner.is_a?(ProjectSeasonApplyChild)
            owner.get_donate_items.each do |item|
              if source.balance > item.surplus_money
                donate_records << self.create!(source: source, kind: kind, owner: item, amount: item.surplus_money, income_record_id: income_record_id, donation_id: donation_id, agent: params[:agent], donor: params[:donor])
                item.accept_donate(donate_records)
              end
            end
          else
            owner.get_donate_items.each do |item|
              if (source.balance - donate_records.sum{|r| r.amount}) > 0
                donate_amount = [item.surplus_money, source.balance].min
                donate_records << self.create!(source: source, kind: kind, owner: item, amount: donate_amount, income_record_id: income_record_id, donation_id: donation_id, agent: params[:agent], donor: params[:donor])
                item.accept_donate(donate_records)
              end
            end
          end

        end
      end

      donate_amount =  donate_records.sum{|r| r.amount}
      source.balance -= donate_amount
      source.save!

      reback = amount.to_f - donate_amount
      if reback > 0
        # 判断是否超捐，超捐退回余额，并扣除income_record balance
        if kind.to_s == 'user_donate' && source.is_a?(IncomeRecord) # 在线支付
          source.balance -= reback
          user = source.donor
          user.lock!
          user.balance += reback
          user.save!
        else
          result = false
          raise ActiveRecord::Rollback, "超捐"
        end
      end
      source.save! # 解锁
      result = true
    end
    return result
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

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :project_id, :project_season_apply_id, :project_season_apply_child_id)
      json.project_alias self.project.try(:alias)
      json.donor self.donor.try(:name)
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

  # def detail_builder
  #   Jbuilder.new do |json|
  #     json.(self, :id, :project_id, :promoter_id, :owner_id, :owner_type)
  #     json.title self.show_title
  #     json.donor self.donor.try(:name)
  #     json.agent self.agent.try(:name)
  #     json.user_name self.donor.try(:name) || '爱心人士'
  #     json.user_avatar self.donor.try(:user_avatar)
  #     json.time self.created_at.strftime('%Y-%m-%d %H:%M:%S')
  #     json.amount number_to_currency(self.amount)
  #     json.by_team self.team.present?
  #     json.team_name self.team.present? ? self.team.name : ''
  #     json.project self.try(:project).try(:name)
  #     json.donate_name self.try(:donate_item).try(:name) || self.try(:project).try(:name)
  #     json.apply_name self.try(:apply).try(:name)
  #     json.project_image_mode self.try(:project).try(:image).present?
  #     json.project_image self.try(:project).try(:project_image).to_s
  #     json.apply_name self.apply.try(:name)
  #     json.apply_image_mode self.apply.try(:cover_image).present?
  #     json.apply_image self.apply.cover_image_url(:little).to_s if self.apply && self.apply.cover_image
  #     json.income_source self.try(:income_record).try(:income_source).try(:name)
  #     json.income_kind self.try(:income_record).try(:income_source).present? ? self.try(:income_record).try(:income_source).enum_name(:kind) : ''
  #     json.donate_project self.donate_project
  #     json.donate_apply_path_name self.view_project_detail_path_name
  #     json.donate_apply_path_params self.view_project_detail_path_params
  #   end.attributes!
  # end

  def self.select_record(agent_id, owner_id = nil)
    if owner_id.present?
      self.where(agent_id: agent_id, owner_id: owner_id)
    else
      self.where(agent_id: agent_id)
    end
  end

  def apply_image
    apply_name = if self.owner_type == 'DonateItem' || self.owner_type == 'ProjectSeasonApply'
      self.owner.proejct.try(:icon_url, :tiny)
    elsif self.owner_type == 'GshChildGrant'
      self.child.try(:avatar_url, :tiny)
    elsif self.owner_type == 'ProjectSeasonApplyChild'
      self.owner.try(:avatar_url, :tiny)
    elsif self.owner_type == 'ProjectSeasonApplyBookshelf'
      self.owner.apply.try(:cover_url, :tiny)
    elsif self.owner_type == 'CampaignEnlist'
      self.owner.campaign.try(:image_url, :tiny)
    end
    apply_name
  end

  def apply_name
    apply_name = if self.owner_type == 'DonateItem' || self.owner_type == 'ProjectSeasonApply'
      self.owner.name
    elsif self.owner_type == 'GshChildGrant'
      self.child.try(:name).to_s + ' · ' + self.owner.try(:title).to_s
    elsif self.owner_type == 'ProjectSeasonApplyChild'
      self.owner.name
    elsif self.owner_type == 'ProjectSeasonApplyBookshelf'
      self.owner.apply.name
    elsif self.owner_type == 'CampaignEnlist'
      self.owner.campaign.name
    end
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
    case self.owner
    when GshChildGrant
      self.project_season_id = self.owner.project_season_id
      self.project_season_apply_id = self.owner.project_season_apply_id
      self.project_season_apply_child_id = self.owner.project_season_apply_child_id
    when ProjectSeasonApplyChild, ProjectSeasonApplyBookshelf
      self.project_id = self.owner.project_id
      self.project_season_id = self.owner.project_season_id
      self.project_season_apply_id = self.owner.project_season_apply_id
    when ProjectSeasonApply
      self.project_id = self.owner.project_id
      self.project_season_id = self.owner.project_season_id
    when BookshelfSupplement
      self.project_id = self.owner.project_id
      self.project_season_apply_id = self.owner.try(:project_season_apply_id)
    when DonateItem
      self.project_id = self.owner.project_id
    end
  end

end
