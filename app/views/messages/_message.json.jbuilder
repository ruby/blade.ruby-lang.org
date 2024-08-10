json.extract! message, :id, :subject, :from, :body, :created_at, :updated_at
json.url message_url(message, format: :json)
