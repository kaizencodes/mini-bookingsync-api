Rails.application.routes.draw do
  resources :bookings do
    collection do
      get :calculate_price
    end
  end
  resources :rentals
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
