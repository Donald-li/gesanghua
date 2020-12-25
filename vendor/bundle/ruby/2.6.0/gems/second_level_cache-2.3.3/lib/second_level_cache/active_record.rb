require 'second_level_cache/mixin'
require 'second_level_cache/active_record/base'
require 'second_level_cache/active_record/core'
require 'second_level_cache/active_record/fetch_by_uniq_key'
require 'second_level_cache/active_record/finder_methods'
require 'second_level_cache/active_record/persistence'
require 'second_level_cache/active_record/belongs_to_association'
require 'second_level_cache/active_record/has_one_association'
require 'second_level_cache/active_record/preloader'

# http://api.rubyonrails.org/classes/ActiveSupport/LazyLoadHooks.html
# ActiveSupport.run_load_hooks(:active_record, ActiveRecord::Base)
ActiveSupport.on_load(:active_record) do
  include SecondLevelCache::Mixin
  prepend SecondLevelCache::ActiveRecord::Base
  extend SecondLevelCache::ActiveRecord::FetchByUniqKey
  prepend SecondLevelCache::ActiveRecord::Persistence

  ActiveRecord::Associations::BelongsToAssociation.send(:prepend, SecondLevelCache::ActiveRecord::Associations::BelongsToAssociation)
  ActiveRecord::Associations::HasOneAssociation.send(:prepend, SecondLevelCache::ActiveRecord::Associations::HasOneAssociation)
  ActiveRecord::Associations::Preloader::BelongsTo.send(:prepend, SecondLevelCache::ActiveRecord::Associations::Preloader::BelongsTo)
end
