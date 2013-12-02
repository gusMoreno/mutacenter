FSI::Application.routes.draw do

  get "busca/busca"

  root to: 'static_pages#home'
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :genotipagems

  resources :exames

  resources :esquemas

  resources :pacientes , :except => :show

  resources :mutacaos

  resources :medicamentos

  get  "/pacientes/mostra_busca"
  post "/pacientes/mostra_busca"
  get  "/pacientes/busca"
  post "/pacientes/busca"
  match "/pacientes/:paciente" => "pacientes#mostra_busca"

  match '/carosel', to: 'static_pages#carosel'
  match '/test', to: 'static_pages#test'

  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete
  
  match '/teste', to: 'static_pages#paginaEntrada'
  match '/teste2', to: 'static_pages#cadastroUsuario' 
  match '/teste3', to: 'static_pages#index'

  match '/import' => 'static_pages#import', :as => :import , :via => [:get, :post]
  match '/export', to: 'static_pages#export'
  match '/exportarErros', to: 'static_pages#exportarErros'
  match '/exportMDR', to: 'static_pages#exportMDR'
  match '/exportITRN', to: 'static_pages#exportITRN'
  match '/exportITRNN', to: 'static_pages#exportITRNN'

  match '/patients',     to: 'static_pages#patients'
  match '/manual',     to: 'static_pages#manual'
  match '/busca_personalizada',         to: 'static_pages#help'
  match '/about',        to: 'static_pages#about'
  match '/contact',      to: 'static_pages#contact'



  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
