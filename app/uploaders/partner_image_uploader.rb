class PartnerImageUploader < BaseUploader

  process :auto_orient

  version :tiny do
    process :resize_to_fill => [150, 60]
  end

end
