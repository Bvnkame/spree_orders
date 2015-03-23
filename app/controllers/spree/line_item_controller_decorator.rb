Spree::Api::LineItemsController.class_eval do
  def create
    p params['order_type']
    if params['order_type'].downcase == "dish"
      variant = Spree::Product.find(params[:line_item][:product_id])
    elsif params['order_type'].downcase == "box"
      variant = Bm::Box.find(params[:line_item][:box_id])
    end
    @line_item = order.contents.add(
      variant,
      params[:line_item][:quantity] || 1,
      line_item_params[:options] || {}
      )

    if @line_item.errors.empty?
      respond_with(@line_item, status: 201, default_template: :show)
    else
      invalid_resource!(@line_item)
    end
  end
end