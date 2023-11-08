# == Schema Information
#
# Table name: reported_cars
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  car_id     :integer          not null
#  report_id  :integer          not null
#
# Indexes
#
#  index_reported_cars_on_car_id_and_report_id  (car_id,report_id) UNIQUE
#
class ReportedCar < ApplicationRecord
end
