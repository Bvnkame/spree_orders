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
          options = {:delivery_date => param[:delivery_date]}
          @line_item = order.contents.adddish(
            variant,
            param[:quantity] || 1,
            options || {}
            )
        elsif param[:order_type].downcase == "box"
          variant = Bm::Box.find(param[:product_id])
          options = {:delivery_date => param[:delivery_date]}
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

  def update_status
    @order = Spree::Order.find_by(number: params[:order_number])
    authorize! :update, @order

    @line_items = @order.line_items.where(delivery_date: line_item_params_for_change_status[:delivery_date])
    @line_items.update_all(status: line_item_params_for_change_status[:status].downcase)

    items_count = @order.line_items.count
    complete_items_count = @order.line_items.where(status: "complete").count

    if items_count == complete_items_count
      @order.update(state: "complete")
    end

    @status = [{ "messages" => "Update Status Successful"}]
    render "spree/api/logger/log", status: 201
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
  def line_item_params_for_change_status
    params.require(:line_item).permit(
      :status,
      :delivery_date)
  end
end