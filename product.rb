class Product
  attr_accessor :name, :unit_price, :sale, :sale_quantity, :sale_price

  def initialize(name, info = {})
    @name = name
    info.each { |key, value| send("#{key}=", value) }
  end

  def name
    @name.capitalize
  end

  def unit_price=(value)
    @unit_price = Money.from_amount(value)
  end

  def sale_price=(value)
    @sale_price = Money.from_amount(value)
  end

  def on_sale?
    sale == true
  end

  def price(count)
    cost = count * unit_price
    saved = Money.new(0)
    if on_sale?
      sale_cost = (count / sale_quantity) * sale_price + (count % sale_quantity) * unit_price
      saved = cost - sale_cost
      cost = sale_cost
    end
    [cost, saved]
  end

  def to_s
    "#{name}\t#{unit_price.format}#{"\t\t#{sale_quantity} for #{sale_price.format}" if on_sale?}"
  end
end