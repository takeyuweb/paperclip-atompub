Rails.application.routes.draw do
  resources :users
  mount PaperclipAtompub::Engine => "/paperclip-atompub"
end
