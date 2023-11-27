# == Schema Information
#
# Table name: blu_iterators
#
#  id         :bigint           not null, primary key
#  iterator   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class BluIterator < ApplicationRecord
end
