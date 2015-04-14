Spree::Core::Engine.routes.draw do
  # Add your extension routes here
   get 'api/orders/mine/past', to: 'api/orders#mine_past'
   get 'api/orders/mine/upcoming', to: 'api/orders#mine_upcoming'
end
