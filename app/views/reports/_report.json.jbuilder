json.extract! report, :id, :lat, :lng, :string, :reporter_id, :address_street, :address_zip, :blu_id, :complete_blu, :description, :category, :created_at, :updated_at
json.url report_url(report, format: :json)
