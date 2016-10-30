class Tournament < ApplicationRecord
  attr_accessor  :profile_picture
  has_many :tournament_events, dependent: :destroy
  has_many :tournament_tickets, dependent: :destroy
  has_many :people

  validates_presence_of :name, :venue_address, :start_date
  validates_numericality_of :total_player_tickets, :total_audience_tickets, only_integer: true, greater_than_or_equal_to: 0
  validate :start_date_is_not_past

  def start_date_is_not_past
    if start_date.present? && start_date < Date.today
      errors.add(:start_date, "can't be in the past")
    end
  end

  # Functionality used by mapping view in welcome/hello_world
  geocoded_by :venue_address
  after_validation :geocode

  # Functionality used by location sorting view in welcome/hello_world
  acts_as_mappable :distance_field_name => :venue_address, :lat_column_name => :latitude, :lng_column_name => :longitude

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
end
