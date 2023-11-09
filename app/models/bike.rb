# == Schema Information
#
# Table name: bikes
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  bike_index_id :integer          not null
#  owner_id      :integer          not null
#
class Bike < ApplicationRecord
end
