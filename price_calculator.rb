require 'yaml'
require_relative 'store'

begin
  # Read price data from yaml file ensuring that their keys are symbols
  products = YAML.load(File.read('product_list.yml'), symbolize_names: true)
  store = Store.new(products)
  # List all available products prior to purchase
  store.print_products
  # Accept user input of items purchased and print receipt
  store.make_purchase
rescue => e
  puts "Error: #{e.message}"
rescue SystemExit, Interrupt
  puts "\nGoodbye"
end