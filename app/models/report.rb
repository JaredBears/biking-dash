# == Schema Information
#
# Table name: reports
#
#  id             :bigint           not null, primary key
#  address_city   :string
#  address_state  :string
#  address_street :string
#  address_zip    :string
#  body           :string
#  category       :string           not null
#  complete_blu   :boolean
#  lat            :string
#  lng            :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  blu_id         :integer
#  reporter_id    :integer          not null
#
class Report < ApplicationRecord
  has_many_attached :images
end
