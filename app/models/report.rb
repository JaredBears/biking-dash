class Report < ApplicationRecord
  validates :lat, presence: true
  validates :lon, presence: true
  validates :category, presence: true
  validates :reporter_id, presence: true
end
