class SpecialBannerUploader < BaseUploader

  process :auto_orient

  version :tiny do
    process :resize_to_fill => [284, 284]
  end
end
