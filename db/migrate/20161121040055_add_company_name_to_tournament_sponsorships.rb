class AddCompanyNameToTournamentSponsorships < ActiveRecord::Migration[5.0]
  def change
    add_column :tournament_sponsorships, :company_name, :string
  end
end
