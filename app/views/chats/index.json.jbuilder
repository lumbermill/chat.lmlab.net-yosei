json.array!(@chats) do |chat|
  json.extract! chat, :id, :user, :message, :created_at
  json.url chat_url(chat, format: :json)
end
