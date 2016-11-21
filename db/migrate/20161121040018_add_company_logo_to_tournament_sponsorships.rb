class AddCompanyLogoToTournamentSponsorships < ActiveRecord::Migration[5.0]
  def change
    add_column :tournament_sponsorships, :company_logo, :string
  end
end
