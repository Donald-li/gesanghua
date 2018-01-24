class Asset::ProjectReportFile < Asset
  after_destroy :destroy_activity
  mount_uploader :file, AssetUploader

  #删除附件
  def destroy_activity

  end
end
