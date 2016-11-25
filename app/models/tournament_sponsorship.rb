class TournamentSponsorship < ApplicationRecord
	belongs_to :tournament
	validates_presence_of :company_name, :sponsor_type
end
