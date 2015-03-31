Spree::Api::LineItemsController.class_eval do

  def index
    @order = Spree::Order.where(number: order_id).first 
    authorize! :read, @order
    render "spree/api/line_items/index"
  end

  def create
    if params[:line_item]['order_type'].downcase == "dish"
      variant = Spree::Product.find(params[:line_item][:product_id])
      options = {:delivery_date => line_item_params[:delivery_date]}
      @line_item = order.contents.adddish(
        variant,
        params[:line_item][:quantity] || 1,
        options || {}
        )
      if @line_item.errors.empty?
        @status = [{ "messages" => "Add Dish Successful"}]
        render "spree/api/logger/log", status: 201
      else
        invalid_resource!(@line_item)
      end

    elsif params[:line_item]['order_type'].downcase == "box"
      variant = Bm::Box.find(params[:line_item][:product_id])
      options = {:delivery_date => line_item_params[:delivery_date]}
      @line_item = order.contents.addbox(
        variant,
        params[:line_item][:quantity] || 1,
        options || {}
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
    if @line_item.update(line_item_params_for_update)
      @line_item.reload
      @status = [{ "messages" => "Update Line_Item in Order Successful"}]
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
      :order_type,
      :quantity,
      :product_id,
      :delivery_date,
      option: line_item_options)
  end

  def line_item_params_for_update
    params.require(:line_item).permit(
      :quantity,
      :delivery_date,
      option: line_item_options)
  end
end