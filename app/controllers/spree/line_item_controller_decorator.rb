Spree::Api::LineItemsController.class_eval do
  def create
    if params['order_type'].downcase == "dish"
      variant = Spree::Product.find(params[:line_item][:product_id])
      @line_item = order.contents.adddish(
        variant,
        params[:line_item][:quantity] || 1,
        line_item_params[:options] || {}
        )
      if @line_item.errors.empty?
        @status = [{ "messages" => "Add Dish Successful"}]
        render "spree/api/logger/log", status: 201
      else
        invalid_resource!(@line_item)
      end

    elsif params['order_type'].downcase == "box"
      variant = Bm::Box.find(params[:line_item][:product_id])
      @line_item = order.contents.addbox(
        variant,
        params[:line_item][:quantity] || 1,
        line_item_params[:options] || {}
        )
      if @line_item.errors.empty?
        @status = [{ "messages" => "Add Box Successful"}]
        render "spree/api/logger/log", status: 201
      else
        invalid_resource!(@line_item)
      end
    end
  end


  def update
    @line_item = find_line_item
    if @order.contents.update_cart(line_items_attributes)
      @line_item.reload
      @status = [{ "messages" => "Update Box Successful"}]
      render "spree/api/logger/log", status: 200
    else
      invalid_resource!(@line_item)
    end
  end

  def destroy
    @line_item = find_line_item
    if @line_item
      @line_item.destroy
      @status = [{ "messages" => "Delete Box Successful"}]
      render "spree/api/logger/log", status: 201
    else
      raise ActiveRecord::RecordNotFound, "Line item not found for box"
    end
    
  end




  private
  def line_item_params
    # params.require(:order_type)
    params.require(:line_item).permit(
      :quantity,
      :product_id,
      option: line_item_options)
  end
end