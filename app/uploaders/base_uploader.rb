# -*- encoding : utf-8 -*-
class BaseUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  def public_url(version=nil)
    "http://#{Settings.app_host}/#{self.url(version)}"
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id / 10000}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    #"/assets/missing/missing.jpg"
    "missing/#{model.class.to_s.underscore}/#{mounted_as}/#{[version_name, "default.png"].compact.join('_')}"
  end

  def filename
     @name ||= "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png svg)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  def get_version_dimensions
    `identify -format "%wx%h" #{file.path}`.split(/x/)
  end

  def auto_orient
    manipulate! do |image|
      image.tap(&:auto_orient)
    end
  end

  def watermark
    manipulate! do |img|
      path = "#{Rails.root}/app/assets/images/watermark.png"
      img = img.composite(MiniMagick::Image.open(path), "jpg") do |c|
        c.gravity "SouthEast"
      end
    end
  end
  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(16))
  end
end
