Spree::Core::Engine.routes.draw do
  # Add your extension routes here
   get 'api/orders/mine/orders', to: 'api/orders#mine_orders'
   get 'api/orders/mine/upcoming', to: 'api/orders#mine_upcoming'
end
