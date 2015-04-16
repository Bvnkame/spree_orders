Spree::Api::LineItemsController.class_eval do

  def index
    @order = Spree::Order.where(number: order_id).first 
    authorize! :read, @order
    render "spree/api/line_items/index"
  end

  def create
    Spree::LineItem.transaction do
      line_item_params[:line_item].each do |param|
        if param[:order_type].downcase == "dish"
          variant = Spree::Product.find(param[:product_id])
          options = {:delivery_date => param[:delivery_date], :status => "cart"}
          @line_item = order.contents.adddish(
            variant,
            param[:quantity] || 1,
            options || {}
            )
        elsif param[:order_type].downcase == "box"
          variant = Bm::Box.find(param[:product_id])
          options = {:delivery_date => param[:delivery_date], :status => "cart"}
          @line_item = order.contents.addbox(
            variant,
            param[:quantity] || 1,
            options || {}
            )
        end
      end
    end
    @status = [{ "messages" => "Add Line Items in Order Successful"}]
    render "spree/api/logger/log", status: 201
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
      @status = [{ "messages" => "Delete Line Item in Order Successful"}]
      render "spree/api/logger/log", status: 201
    else
      raise ActiveRecord::RecordNotFound, "Line item not found for box"
    end
    
  end

  private
  def line_item_params
    # params.require(:order_type)
    params.permit( :line_item => [
      :order_type,
      :quantity,
      :product_id,
      :delivery_date,
      option: line_item_options
      ])
  end

  def line_item_params_for_update
    params.require(:line_item).permit(
      :quantity,
      :delivery_date,
      option: line_item_options)
  end
end