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
    if self.file.content_type.start_with? 'image/'
      self.width, self.height = ::MiniMagick::Image.open(file.file.path)[:dimensions]
    end
  end

  protected
  def generate_token
    self.protect_token = SecureRandom.hex(10)
  end
end
