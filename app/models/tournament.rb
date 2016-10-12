class Tournament < ApplicationRecord
  has_many :tournament_events, dependent: :destroy
  has_many :tournament_tickets, dependent: :destroy
  has_many :person

  validates_presence_of :name, :venue_address, :start_date
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


  # create_tournament creates a new tournament
  def create_tournament
    self.logo = Image.store(:logo, self.logo)
    self.venue_logo = Image.store(:venue_logo, self.venue_logo)
    self.profile_pictures = Image.store(:profile_pictures, self.profile_pictures)
    self.save
  end
end
