
require 'rails_helper'

RSpec.describe MigrateHelper, type: :model do

  it '测试迁移用户' do
    MigrateHelper.migrate_donors
    MigrateHelper.migrate_profiles
    MigrateHelper.migrate_schools
    MigrateHelper.migrate_teachers
    MigrateHelper.migrate_children
    MigrateHelper.migrate_donations
  end

end
