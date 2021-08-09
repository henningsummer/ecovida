# == Schema Information
#
# Table name: core_coordinators
#
#  id         :integer          not null, primary key
#  current    :boolean
#  email      :string
#  name       :string
#  phone      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  core_id    :integer
#
# Indexes
#
#  index_core_coordinators_on_core_id  (core_id)
#
# Foreign Keys
#
#  fk_rails_...  (core_id => cores.id)
#
class CoreCoordinator < ActiveRecord::Base
  belongs_to :core
  validates_presence_of :name, :phone, :email, :core_id
end
