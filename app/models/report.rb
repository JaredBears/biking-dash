# == Schema Information
#
# Table name: reports
#
#  id             :bigint           not null, primary key
#  address_street :string
#  address_zip    :string
#  category       :enum             not null
#  description    :string
#  lat            :float            not null
#  lon            :float            not null
#  neighborhood   :string
#  suburb         :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  blu_id         :bigint
#  reporter_id    :bigint           not null
#
# Indexes
#
#  index_reports_on_blu_id       (blu_id)
#  index_reports_on_reporter_id  (reporter_id)
#
class Report < ApplicationRecord
  validates :lat, presence: true
  validates :lon, presence: true
  validates :category, presence: true
  validates :reporter_id, presence: true

  has_many_attached :images

  acts_as_mappable  :default_units => :miles,
                    :default_formula => :sphere,
                    :distance_field_name => :distance,
                    :lat_column_name => :lat,
                    :lng_column_name => :lon
end
