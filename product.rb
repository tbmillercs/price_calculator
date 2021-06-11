class Product
  attr_accessor :name, :unit_price, :sale, :sale_quantity, :sale_price

  ##
  # Initialize product. Name and unit_price are required. If the
  # product is on sale, then sale_quantity and sale_price are also
  # required.
  def initialize(name, info = {})
    raise ArgumentError.new('Products must contain a name.') unless name

    self.name = name
    self.unit_price = info[:unit_price]
    self.sale = info[:sale]
    self.sale_quantity = info[:sale_quantity]
    self.sale_price = info[:sale_price]
  end

  ##
  # Names should always be capitalized when accessed
  def name
    @name.capitalize
  end

  ##
  # Unit price is a required parameter. It must be a number and
  # it is saved as a Money object
  def unit_price=(value)
    raise ArgumentError.new("A product's unit price must be numeric.") unless value.is_a?(Numeric)
    @unit_price = Money.from_amount(value)
  end

  ##
  # Sale price is a required parameter if the product is on sale.
  # It must be a number and it is saved as a Money object with the
  # default value of 0
  def sale_price=(value)
    unless value.is_a?(Numeric)
      raise ArgumentError.new("A product's sale price must be numeric if it is on sale.") if self.on_sale?
      value = 0
    end
    @sale_price = Money.from_amount(value)
  end

  ##
  # Sale quantity is a required parameter if the product is on sale.
  # It must be a number greater than 0 with the default value of 1.
  def sale_quantity=(value)
    unless value.is_a?(Numeric) && value > 0
      raise ArgumentError.new("A product's sale quantity must be numeric and greater than 0 if it is on sale.") if self.on_sale?
      value = 1
    end
    @sale_quantity = value
  end

  ##
  # Only `true` will indicate that this product is on sale
  def on_sale?
    sale == true
  end

  ##
  # Get the total cost for a given number of this product, whether
  # it is on sale or not.
  def total_cost(count)
    on_sale? ? sale_price_total(count) : full_price_total(count)
  end

  ##
  # The total cost of a given number of this product if it is not on sale.
  def full_price_total(count)
    count * unit_price
  end

  ##
  # The total cost of a given number of this product if is on sale.
  def sale_price_total(count)
    (count / sale_quantity) * sale_price + (count % sale_quantity) * unit_price
  end

  ##
  # Format the to_s for use when printing all prices
  def to_s
    "#{name}\t#{unit_price.format}#{"\t\t#{sale_quantity} for #{sale_price.format}" if on_sale?}"
  end
end