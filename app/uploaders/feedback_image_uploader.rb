class FeedbackImageUploader < BaseUploader

  process :auto_orient

  version :tiny do
    process :resize_to_fill => [130, 130]
  end
end
