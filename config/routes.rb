Spree::Core::Engine.routes.draw do
  # Add your extension routes here
   get 'api/orders/mine/past', to: 'api/orders#mine_past'
   get 'api/orders/mine/upcoming', to: 'api/orders#mine_upcoming'

   post 'api/placeorder/:order_number', to: 'api/orders#place_order'
   post 'api/orders/:order_number/line_items/status', to 'api/line_items#update_status'
end
