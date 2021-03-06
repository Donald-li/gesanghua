# == Schema Information
#
# Table name: sequences
#
#  id         :bigint(8)        not null, primary key
#  kind       :string
#  prefix     :string
#  value      :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Sequence < ApplicationRecord

  validates :value, uniqueness: true

  def self.get_seq(kind: :order_no, prefix: '', count: 1, length: 5, start: 1, save: true)
    seq = self.where(kind: kind, prefix: prefix).first || self.create(kind: kind, prefix: prefix, value: start)
    first = nil
    seq.with_lock do
      first = seq.value.to_i
      seq.update_attribute(:value, first + count) if save
    end
    seqs = (first .. first+count-1).to_a.map{|s| "#{prefix}#{s.to_s.rjust(length, '0')}" }

    # seqs.size > 1 ? seqs : seqs.first
    seqs.first
  end
end
