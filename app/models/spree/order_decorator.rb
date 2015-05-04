Spree::Order.class_eval do 

	ORDER_NUMBER_LENGTH  = 9
  ORDER_NUMBER_LETTERS = false
  ORDER_NUMBER_PREFIX  = 'R'

  def self.new_order(user)
  	@order = Spree::Order.new

  	@order.generate_order_number
  	@order.user = user
  	@order.state = "cart"

  	@order.save!
  end


	def generate_order_number(options = {})
    options[:length]  ||= ORDER_NUMBER_LENGTH
    options[:letters] ||= ORDER_NUMBER_LETTERS
    options[:prefix]  ||= ORDER_NUMBER_PREFIX

    possible = (0..9).to_a
    possible += ('A'..'Z').to_a if options[:letters]

    self.number ||= loop do
      # Make a random number.
      random = "#{options[:prefix]}#{(0...options[:length]).map { possible.shuffle.first }.join}"
      # Use the random  number if no other order exists with it.
      if self.class.exists?(number: random)
        # If over half of all possible options are taken add another digit.
        options[:length] += 1 if self.class.count > (10 ** options[:length] / 2)
      else
        break random
      end
    end
  end

	def total_price
		total = 0
		self.line_items.each do |line_item|
			total += line_item.price.to_f * line_item.quantity.to_f
		end
		total
	end

	def find_line_item_by_product(variant, options = {})
		line_items.detect { |line_item|
			line_item.product_id == variant.id 
		}
	end

	def find_line_item_by_box(variant, options = {})
		line_items.detect { |line_item|
			line_item.box_id == variant.id
		}
	end

	def find_past_order
		self.line_items.where(:status => "complete") 
	end
	
	def find_upcoming_order
		self.line_items.where(:status => "delivery") 
	end

end