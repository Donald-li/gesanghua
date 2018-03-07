module HasAsset
  extend ActiveSupport::Concern

  included do |base|
  end

  module ClassMethods
    def has_one_asset(key='asset', class_name: 'Asset')
      has_one key, class_name: class_name, as: :owner, dependent: :destroy
      accepts_nested_attributes_for key, update_only: true

      define_method("#{key}_url") do |version|
        if self.try(key).try(:file).present?
          if version
            self.try(key).try(:file).try(:url, version)
          else
            self.try(key).try(:file).try(:url)
          end
        else
          return ActionController::Base.helpers.asset_path('default.jpg')
        end
      end

      define_method("attach_#{key}") do |asset_id|
        asset = Asset.find_by(id: asset_id)
        if asset
          self.send("#{key}=", asset)
        end
      end
    end

    def has_many_assets(key='assets', class_name: 'Asset')
      has_many key, class_name: class_name, as: :owner, dependent: :destroy
      accepts_nested_attributes_for key, allow_destroy: true
      define_method("attach_#{key}") do |ids|
        self.send("#{key.to_s.singularize}_ids=", ids)
      end
    end
  end
end
