class VisitImageUploader < BaseUploader

  process :auto_orient

  version :tiny do
    process :resize_to_fill => [320, 160]
  end
end
