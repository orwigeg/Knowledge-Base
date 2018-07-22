Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  resources :posts do 
  	resources :responses
  end
  root 'posts#index', as: 'home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
