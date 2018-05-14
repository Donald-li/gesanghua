class BadgeIconUploader < BaseUploader
  def default_url
    ActionController::Base.helpers.image_url 'medal-icon.png'
    # "/assets/images/missing.jpg"
  end
end
