Rails.application.routes.draw do
  root 'data#new'

  get 'data/:id/configure', to: 'data#configure', as: :configure_datum
  get 'data/:id/print', to: 'data#print', as: :print_datum
  get 'data/:id/chart_data', to: 'data#chart_data', as: :datum_chart_data
  resources :data

end
