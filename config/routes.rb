Rails.application.routes.draw do
  # Responsáveis Financeiros
  resources :guardians do
    member do
      get 'payment_plans', to: 'guardians#payment_plans'
      get 'charges', to: 'guardians#charges'
      get 'charges/count', to: 'guardians#charges_count'
    end
  end

  # Centros de Custo
  resources :cost_centers

  # Planos de Pagamento
  resources :payment_plans do
    member do
      get 'total', to: 'payment_plans#total'
    end
  end

  # Cobranças
  resources :charges do
    member do
      post 'payments', to: 'charges#create_payment'
    end
  end
end
