# == Schema Information
#
# Table name: sms_codes
#
#  id         :integer          not null, primary key
#  kind       :integer
#  mobile     :string
#  code       :string
#  state      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe SmsCode, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
