class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :decode_page, ->(params) { page(params[:page]).per(params[:per] || 20) }

  def self.all_to_hash
    self.all.map{|c| [c.name, c.id]}
  end
end
