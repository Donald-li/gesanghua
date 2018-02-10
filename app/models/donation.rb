# == Schema Information
#
# Table name: donations # 可捐助项目表
#
#  id         :integer          not null, primary key
#  name       :string                                 # 名称
#  describe   :string                                 # 说明
#  state      :integer                                # 状态： 1：显示 2：隐藏
#  position   :integer                                # 排序
#  fund_id    :integer                                # 基金id
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Donation < ApplicationRecord

  attr_accessor :logo_id, :form_attributes

  include HasAsset
  has_one_asset :logo, class_name: 'Asset::DonationLogo'

  belongs_to :fund, optional: true
  has_many :donate_records
  has_many :amount_tabs

  acts_as_list column: :position
  scope :sorted, ->{ order(position: :asc) }


  enum state: {show: 1, hidden: 2} # 状态：1:显示 2:隐藏
  default_value_for :state, 1

  def options_builder
    Jbuilder.new do |json|
      json.name self.name
      json.value self.id
    end.attributes!
  end

  def self.find_donation_project(value)
    # if value == 'toGsh'
    #   nil
    # else
      self.find(value.to_i)
    # end
  end

end
