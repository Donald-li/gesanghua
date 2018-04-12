class SpecialBannerUploader < BaseUploader

  process :auto_orient

  version :tiny do
    process :resize_to_fill => [284, 284]
  end

  version :medium do #pc端专题banner
    process :resize_to_fill => [240, 140]
  end

  version :large do #pc端专题banner
    process :resize_to_fill => [1440, 370]
  end
end
