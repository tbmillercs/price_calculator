require 'readline'
require 'money'
Money.rounding_mode = BigDecimal::ROUND_HALF_UP
Money.locale_backend = nil
Money.default_currency = 'USD'
require_relative 'product'

class Store
  def initialize(product_list = {})
    @products = {}
    product_list.each { |name, info| add_product(name, info) }
  end

  def add_product(name, info)
    @products[name.downcase.to_sym] = Product.new(name, info)
  end

  def make_purchase
    puts 'Please enter all the items purchased separated by a comma:'
    input = Readline.readline('> ', true).split(',')
    items = count_items(input)
    calculate_and_print_receipt(items)
  rescue => e
    puts "Error: #{e.message}, please try again"
    make_purchase
  end

  def count_items(items)
    items.each_with_object({}) do |item, obj|
      sym = item.strip.downcase.to_sym
      raise 'Item not found' unless @products.has_key?(sym)

      obj[sym] = 1 + (obj[sym] || 0)
    end
  end

  def calculate_and_print_receipt(items)
    total_cost = Money.new(0)
    total_saved = Money.new(0)

    puts "Item\tQuantity\tPrice"
    puts '--------------------------------------'
    items.each do |name, count|
      product = @products[name]
      price, saved = product.price(count)

      puts "#{product.name}\t#{count}\t\t#{price.format}"

      total_cost += price
      total_saved += (saved || 0)
    end
    puts "\nTotal price: #{total_cost.format}"
    puts "You saved #{total_saved.format} today."
  end

  def print_products
    puts "Today's prices are:"
    puts '--------------------------------------'
    puts "Item\tUnit price\tSale price"
    puts '--------------------------------------'
    @products.values.each { |product| puts product }
    puts '--------------------------------------'
    puts
  end
end