Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  resources :printing_templates
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
