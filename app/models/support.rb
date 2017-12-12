class Support < ApplicationRecord
  enum state: {show: 1, hidden: 2}
  default_value_for :state, 1

  acts_as_list column: :position

  validates :title, presence: true
  validates :alias, presence: true

  scope :sorted, ->{ order(position: :asc) }

  attr_accessor :image_id

  include HasAsset
  has_one_asset :image, class_name: 'Asset::SupportImage'
end
