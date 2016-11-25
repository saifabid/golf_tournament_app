require 'securerandom'

class Tournament < ApplicationRecord
  attr_accessor  :profile_picture
  has_many :tournament_events, dependent: :destroy
  has_many :tournament_features, dependent: :destroy
  has_many :tournament_tickets, dependent: :destroy
  has_many :tournament_profile_pictures, dependent: :destroy
  has_many :tournament_sponsorships, dependent: :destroy
  has_many :people

  validates_presence_of :name, :venue_address, :start_date
  validates_numericality_of :total_player_tickets, :total_audience_tickets, :total_dinner_tickets, only_integer: true, greater_than_or_equal_to: 0
  validates_numericality_of :gold_sponsor_price, :silver_sponsor_price, :bronze_sponsor_price, :player_price,:spectator_price, :dinner_price, :foursome_price, :numericality => {:greater_than =>0}
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
  acts_as_mappable :distance_field_name => :distance, :lat_column_name => :latitude, :lng_column_name => :longitude

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

  def self.create_private_event_hash
    return SecureRandom.hex(3)
  end
end
