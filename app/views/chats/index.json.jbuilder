json.array!(@chats) do |chat|
  json.extract! chat, :id, :user, :message, :sendtime
  json.url chat_url(chat, format: :json)
end
