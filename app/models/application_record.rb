class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.all_to_hash
    self.all.map{|c| [c.name, c.id]}
  end
end
