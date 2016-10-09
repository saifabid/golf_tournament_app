class Tournament < ApplicationRecord
  has_many :tournament_events, dependent: :destroy
  has_many :tournament_tickets, dependent: :destroy
  has_many :person

  @language_options = [
      ['English', 'english'],
      ['French', 'french']
  ]

  @currency_options = [
      ["CAD", "cad"],
      ["USD", "usd"]
  ]

  def self.language_options
    @language_options
  end

  def self.currency_options
    @currency_options
  end

  # Functionality used by mapping view in welcome/hello_world
  geocoded_by :venue_address
  after_validation :geocode
  
  # Functionality used by location sorting view in welcome/hello_world
  acts_as_mappable :distance_field_name => :venue_address, :lat_column_name => :latitude, :lng_column_name => :longitude

  # Register a new tournament
  def register
    self.save
    return true
  end
end