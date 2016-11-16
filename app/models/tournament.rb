require 'securerandom'

class Tournament < ApplicationRecord
  attr_accessor  :profile_picture
  has_many :tournament_events, dependent: :destroy
  has_many :tournament_tickets, dependent: :destroy
  has_many :people

  validates_presence_of :name, :venue_address, :start_date, :gold_sponsor_price, :silver_sponsor_price, :bronze_sponsor_price, :player_price
  validates_numericality_of :total_player_tickets, :total_audience_tickets, only_integer: true, greater_than_or_equal_to: 0
  validates_numericality_of :gold_sponsor_price, :silver_sponsor_price, :bronze_sponsor_price, :player_price, :numericality => {:greater_than =>0}
  validate :start_date_is_not_past, :no_more_than_12_profile_pictures

  def start_date_is_not_past
    if start_date.present? && start_date < Date.today
      errors.add(:start_date, "can't be in the past")
    end
  end

  def no_more_than_12_profile_pictures
    arr_profile_pictures = Tournament.string_to_arr(profile_pictures)

    if arr_profile_pictures.present? && arr_profile_pictures.length > 12
      errors.add(:profile_pictures, "Can't have more than 12")
    end
  end

  def self.string_to_arr(profile_pictures)
    x = profile_pictures[1..-2]
    x.gsub! '"', ''
    x.gsub! " ", ''
    return x.split(",")
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

  def self.create_private_event_hash
    return SecureRandom.hex(3)
  end
end
