class TournamentSponsorship < ApplicationRecord
  enum sponsor_type: [ :bronze, :silver, :gold ]
end
