class TournamentEvent < ApplicationRecord
  belongs_to :tournament
  validates_presence_of :event_name
end
