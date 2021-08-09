# == Schema Information
#
# Table name: system_logs
#
#  id          :integer          not null, primary key
#  description :string
#  author      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class SystemLog < ActiveRecord::Base
  def self.search query
    query.present? ? where(["description ILIKE :query" , query: "%#{query}%"]) : all
  end
end
