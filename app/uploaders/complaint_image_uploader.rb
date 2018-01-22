class ComplaintImageUploader < BaseUploader

  process :auto_orient

  version :tiny do
    process :resize_to_fill => [400, 400]
  end
end
