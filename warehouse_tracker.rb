class WarehouseTracker
  def initialize
    @products = {} # {product_name => {price: price, stock: stock}}
    @orders = {} # {customer_name => {product_name => [order_amounts]}}
  end
  
  def process_commands(commands)
    commands.each do |command|
      args = command.split
      send(args.first, *args[1..-1])
    end
  end
  
  def register(product, price)
    @products[product] = { price: price.delete_prefix('$').to_f, stock: 0 }
  end
  
  def checkin(product, quantity)
    @products[product][:stock] += quantity.to_i if @products[product]
  end
  
  def order(customer, product, quantity)
    quantity = quantity.to_i
    @orders[customer] ||= {}
    @orders[customer][product] ||= []
    if @products[product] && @products[product][:stock] >= quantity
      @products[product][:stock] -= quantity
      @orders[customer][product] << @products[product][:price] * quantity
    else
      @orders[customer][product] << nil unless @orders[customer][product].include?(nil)
    end
  end
  
  def report
    reports = @orders.map do |customer, products|
      orders_processed = products.reject { |_, amounts| amounts.all?(&:nil?) }
      if orders_processed.empty?
        [customer.capitalize, 'n/a']
      else
        successful_orders = orders_processed.map do |product, amounts|
          "#{product} - $#{'%.2f' % amounts.sum}"
        end.join(', ')
        total_spent = orders_processed.values.flatten.compact.sum
        avg_order_value = total_spent / orders_processed.values.flatten.compact.size
        [customer.capitalize, "#{successful_orders} | Average Order Value: $#{'%.2f' % avg_order_value}"]
      end
    end
    puts reports
    reports.sort_by { |_, report| report == 'n/a' ? 0 : 1 }.map do |customer, report|
      "#{customer}: #{report}"
    end.join("\n")
  end
  
  def start_processing
    commands = $stdin.readlines.map(&:chomp)
    puts commands
    process_commands(commands)
    puts report
  end
end
  
tracker = WarehouseTracker.new
tracker.start_processing if __FILE__ == $PROGRAM_NAME
  
  