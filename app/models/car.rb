# == Schema Information
#
# Table name: cars
#
#  id         :bigint           not null, primary key
#  color      :string
#  make       :string
#  model      :string
#  plate      :citext           not null
#  style      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_cars_on_plate  (plate) UNIQUE
#
class Car < ApplicationRecord
end
