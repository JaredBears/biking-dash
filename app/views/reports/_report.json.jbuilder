json.extract! report, :id, :reporter_id, :category, :address_street, :address_city, :address_state, :address_zip, :lat, :lng, :body, :created_at, :updated_at
json.url report_url(report, format: :json)
