class Tournament < ApplicationRecord
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

end
