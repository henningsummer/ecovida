# == Schema Information
#
# Table name: sigorg_changes
#
#  id             :integer          not null, primary key
#  change_date    :date
#  changed_column :string
#  value          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  sigorg_id      :integer
#
# Indexes
#
#  index_sigorg_changes_on_sigorg_id  (sigorg_id)
#
# Foreign Keys
#
#  fk_rails_...  (sigorg_id => sigorgs.id)
#
class SigorgChange < ActiveRecord::Base
  belongs_to :sigorg
  validates_uniqueness_of :changed_column, scope: :sigorg_id
end
