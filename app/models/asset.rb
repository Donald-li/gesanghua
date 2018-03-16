# == Schema Information
#
# Table name: assets # 资源表
#
#  id            :integer          not null, primary key
#  type          :string
#  owner_type    :string
#  owner_id      :integer
#  position      :integer
#  file          :string
#  file_name     :string
#  file_size     :integer
#  width         :integer
#  height        :integer
#  user_type     :string
#  user_id       :integer
#  protect_token :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Asset < ApplicationRecord
  second_level_cache expires_in: 1.week

  acts_as_list scope: [:owner_type, :owner_id], column: :position

  validates :file, presence: true

  belongs_to :owner, polymorphic: true, optional: true
  belongs_to :user, polymorphic: true, optional: true

  mount_uploader :file, AssetUploader

  before_validation :get_file_info, on: [:create]
  before_create :generate_token

  def get_file_info
    return if self.file.file.blank?
    self.file_name = self.file.file.filename.to_s
    self.file_size = self.file.size
    if self.file.content_type.start_with?('image/') && !self.file.content_type.include?('svg')
      self.width, self.height = ::MiniMagick::Image.open(file.file.path)[:dimensions]
    end
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :protect_token)
      json.url self.file.url
    end.attributes!
  end

  def image_builder(version=nil)
    Jbuilder.new do |json|
      json.id self.id
      json.thumb self.file_url(version)
      json.src self.file_url
      json.w self.width
      json.h self.height
    end
    #code
  end

  protected
  def generate_token
    self.protect_token = SecureRandom.hex(10)
  end
end
