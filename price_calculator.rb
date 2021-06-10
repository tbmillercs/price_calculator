require 'yaml'
require_relative 'store'

begin
  products = YAML.load(File.read('product_list.yml'))
  store = Store.new(products)
  store.print_products
  store.make_purchase
rescue SystemExit, Interrupt
  puts "\nGoodbye"
end