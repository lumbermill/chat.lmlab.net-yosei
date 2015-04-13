Rails.application.routes.draw do
  resources :chats

  root to: "chats#index"
end
