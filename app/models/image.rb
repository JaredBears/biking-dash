# == Schema Information
#
# Table name: images
#
#  id         :bigint           not null, primary key
#  image_url  :string           default("http://placehold.it/300x300"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  bike_id    :integer
#  car_id     :integer
#  ibb_id     :integer
#  owner_id   :integer
#  report_id  :integer
#
class Image < ApplicationRecord
end
