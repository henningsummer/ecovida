Rails.application.routes.draw do
  resource :excluded_data, only: [:show] do
    resources :farmers, only: [:index], module: :excluded_data
    resources :production_unities, only: [:index], module: :excluded_data
    resources :groups, only: [:index], module: :excluded_data
  end

  # Help
  get '/help/reduce_pdf_size'

  get 'document_access_visualizations/core'

  get 'document_access_visualizations/group'

  get 'document_access_visualizations/documents_farmers_and_production_unities'

  get 'document_access_visualizations/farmer'

  get 'document_access_visualizations/production_unity'

  get 'document_access_visualizations/certificate'

  resources :document_visualizations
  get "/home/search" => "home#search"
  get "/home/report" => "home#report"
  resource :user_sessions
  resource :document_visualization_sessions

  namespace :view_reports do
    get '/view_reports' => 'view_reports#index'
    get '/farmer_reports' => 'farmer_reports#index'
    get '/product_reports' => 'product_reports#index'
    get '/city_reports' => 'city_reports#index'
    get '/production_unity_reports' => 'production_unity_reports#index'
  end

  namespace :reports do
    get 'index'
    get 'quantity'
    get 'annuity'
    get 'certified_members'

    get '/core_reports/actual_situation' => 'core_reports#actual_situation'
    get '/core_reports/products' => 'core_reports#products'
    get '/global_reports/actual_situation' => 'global_reports#actual_situation'
    get '/global_reports/annuity' => 'global_reports#annuity'
    post '/global_reports/certificate_documents' => 'global_reports#certificate_documents'
    get '/group_reports/products' => 'group_reports#products'
  end

  resources :document_approvment, only: [:index, :create]
  resources :dac_approvment, only: [:index, :create]
  resources :pending_documents, only: [:index]

  resource :records, only: [:show] do
    resources :documents, module: :records
    resources :logs, only: [:index], module: :records
    resources :unity_suspension_types, except: [:delete], module: :records
    resources :group_types, except: [:delete], module: :records
    resources :product_categories, except: [:delete], module: :records
    resources :products, except: [:delete], module: :records
    resources :scopes, module: :records
    resources :acronyms, module: :records
    resources :suspension_types, module: :records
  end

  resources :groups, except: :delete do
    resources :change_core, module: :groups, only: [:new, :create]
    resources :send_documents, module: :groups
    resources :dac_documents, module: :groups

    get "/outdateds" => "groups#outdateds"
    post "/update_outdateds" => "groups#update_outdateds"
    get "/group_dacs" => "groups#group_dacs"
    post "/group_dacs" => "groups#create_group_dacs"
    resources :certificate_groups, module: :groups do
      resources :certificate, only: [:index, :show]
    end
    resources :production_unities, module: :groups do
      get 'certificates'
      resources :send_documents, module: :production_unities
      post 'remove_suspension' => 'production_unities#remove_suspension'
      post 'set_updated' => 'production_unities#set_updated'
      resources :production_unity_farmers do
        post "" => "production_unity_farmers#change_responsible"
      end
      resources :production_unity_scopes do
        resources :scope_products, only: [:new, :create, :edit, :update, :destroy]
      end
      resources :unity_suspensions
    end
    resources :set_suplentes, except: [:delete, :edit, :update], module: :groups
    resources :farmers, except: :delete do
      post 'set_updated' => 'farmers#set_updated'

      collection do
        get 'validate_name'
      end
      
      get 'certificates'
      resources :farmer_group_changes, module: :farmers
      resources :dacs, except: [:update, :edit], module: :farmers
      resources :daps, except: [:update, :edit], module: :farmers
      resources :farmer_families, module: :farmers
      resources :send_documents, module: :farmers
      resources :farmer_suspensions, module: :farmers
        post 'remove_suspension' => 'farmers#remove_suspension'
    end
  end

  resources :cores, except: [:delete] do
    resources :core_coordinators, except: [:show, :destroy], module: :cores do
      member do
        patch :update_current
      end
    end
    resources :payments, module: :cores
  end

  resources :system_settings, only: [:index, :edit, :update]

  resources :admin_password_updater

  root 'home#index'

end
