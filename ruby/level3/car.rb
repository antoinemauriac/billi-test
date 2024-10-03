class Car
  attr_reader :id, :price_per_day, :price_per_km

  def initialize(attr = {})
    @id = attr[:id]
    @price_per_day = attr[:price_per_day]
    @price_per_km = attr[:price_per_km]
  end
end
