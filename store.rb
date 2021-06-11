require 'readline'
require 'money'
Money.rounding_mode = BigDecimal::ROUND_HALF_UP
Money.locale_backend = nil
Money.default_currency = 'USD'
require_relative 'product'

class Store
  ##
  # Initialize and add all provided products in the format:
  #   { product_name: {  unit_price: value,
  #                      sale: true/false,
  #                      sale_quantity: value,
  #                      sale_price: value } ... }
  def initialize(product_list = {})
    @products = {}
    product_list.each { |name, info| add_product(name, info) }
  end

  ##
  # Products are indexed by their names in symbole form
  def add_product(name, info)
    @products[name.downcase.to_sym] = Product.new(name, info)
  end

  ##
  # To make a purchase, read input from the user, then count and
  # calculate the total cost. If any errors occur, allow the user
  # to enter their input again.
  def make_purchase
    puts 'Please enter all the items purchased separated by a comma:'
    input = Readline.readline('> ', true).split(',')
    items = count_items(input)
    calculate_and_print_receipt(items)
  rescue => e
    puts "Error: #{e.message}, please try again"
    make_purchase
  end

  ##
  # Given an array of items, count the number of times each product
  # is listed in the array. Ensure that all input data uses the same
  # syntax so a proper count can be made.
  def count_items(items)
    items.each_with_object({}) do |item, obj|
      sym = item.strip.downcase.to_sym
      raise 'Item not found' unless @products.has_key?(sym)

      obj[sym] = 1 + (obj[sym] || 0)
    end
  end

  ##
  # Given a hash of items and their counts, look up the cost
  # of these items and print out each item with its information.
  # Keep a running total of both the cost and how much money was
  # saved via sales. Print these at the end.
  def calculate_and_print_receipt(items)
    total_cost = Money.new(0)
    total_saved = Money.new(0)

    puts "Item\tQuantity\tPrice"
    puts '--------------------------------------'
    items.each do |name, count|
      product = @products[name]
      price = product.total_cost(count)
      total_cost += price
      total_saved += product.full_price_total(count) - price if product.on_sale?

      puts "#{product.name}\t#{count}\t\t#{price.format}"
    end
    puts "\nTotal price: #{total_cost.format}"
    puts "You saved #{total_saved.format} today."
  end

  ##
  # Print a list of all available products with their unit prices
  # and sale prices.
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