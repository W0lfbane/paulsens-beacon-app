json.extract! user, :id, :created_at, :updated_at
json.points user.points.value
json.token @encoded_token if @encoded_token.present?