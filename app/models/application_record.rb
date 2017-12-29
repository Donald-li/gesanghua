class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.options_for_select
    self.all.map{|c| [c.name, c.id]}
  end
end
