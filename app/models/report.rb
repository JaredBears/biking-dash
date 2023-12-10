# == Schema Information
#
# Table name: reports
#
#  id             :bigint           not null, primary key
#  address_street :string
#  address_zip    :string
#  category       :enum             not null
#  complete_blu   :boolean          default(FALSE)
#  description    :string
#  lat            :string
#  lng            :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  blu_id         :bigint
#  reporter_id    :bigint           not null
#
class Report < ApplicationRecord
end
