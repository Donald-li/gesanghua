# == Schema Information
#
# Table name: sequences
#
#  id         :integer          not null, primary key
#  kind       :string
#  prefix     :string
#  value      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Sequence, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
