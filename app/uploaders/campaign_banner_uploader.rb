class CampaignBannerUploader < BaseUploader

  process :auto_orient

  version :tiny do
    process :resize_to_fill => [888, 510]
  end
end
