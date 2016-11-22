class Account < ApplicationRecord
  belongs_to :user
  
  validates :first_name, :last_name, presence: true
  validate :birth_date_in_future

  name_regexp = /\A[a-z\s.-]*\z/i
  number_regexp = /\A\+?\d{,3}\s*\(?\s*\d{3}\)?\s*-?\s*\d{3}\s*-?\s*\d{4}\s*\z/
  adr_regexp = /\A[a-z-.',\d\s]*\z/i
  code_regexp = /\A[a-z\d\s]*\z/i

  validates_format_of :first_name, :with => name_regexp, message: "Letters, spaces, dots, and dashes only"
  validates_format_of :middle_name, :with => name_regexp, :allow_blank => true, message: "Letters, spaces, dots, and dashes only"
  validates_format_of :last_name, :with => name_regexp, :allow_blank => true, message: "Letters, spaces, dots, and dashes only"
  validates_format_of :suffix, :with => name_regexp, :allow_blank => true, message: "Letters, spaces, dots, and dashes only"
  validates_format_of :mobile_phone, :with => number_regexp, :allow_blank => true, message: "Sample phone number format: +1(555)555-5555"
  validates_format_of :home_adr1, :with => adr_regexp, :allow_blank => true, message: "Letters, numbers, spaces, periods, commas, and apostrophes only"
  validates_format_of :home_adr2, :with => adr_regexp, :allow_blank => true, message: "Letters, numbers, spaces, periods, commas, and apostrophes only"
  validates_format_of :home_city, :with => adr_regexp, :allow_blank => true, message: "Letters, numbers, spaces, periods, commas, and apostrophes only" 
  validates_format_of :home_province, :with => adr_regexp, :allow_blank => true, message: "Letters, numbers, spaces, periods, commas, and apostrophes only"
  validates_format_of :home_code, :with => code_regexp, :allow_blank => true, message: "Letters, numbers, and spaces only"

  def birth_date_in_future
    if birth.present? && birth > Date.today
      errors.add(:birth, "can't be in the future")
    end
  end
end
