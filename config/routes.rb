Rails.application.routes.draw do
  resources :chats

  root to: "chats#index"
  get 'ranking' => 'chats#ranking'
end
