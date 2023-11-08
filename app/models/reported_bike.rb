# == Schema Information
#
# Table name: reported_bikes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  bike_id    :integer          not null
#  report_id  :integer          not null
#
# Indexes
#
#  index_reported_bikes_on_bike_id_and_report_id  (bike_id,report_id) UNIQUE
#
class ReportedBike < ApplicationRecord
end
