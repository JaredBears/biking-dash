json.extract! image, :id, :image_url, :ibb_id, :report_id, :owner_id, :bike_id, :car_id, :created_at, :updated_at
json.url image_url(image, format: :json)
