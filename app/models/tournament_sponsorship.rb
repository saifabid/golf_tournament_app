class TournamentSponsorship < ApplicationRecord
  belongs_to :tournament
  enum sponsor_type: [ :bronze, :silver, :gold ]
end
