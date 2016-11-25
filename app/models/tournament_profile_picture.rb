class TournamentProfilePicture < ApplicationRecord
  belongs_to :tournament
  validate :no_more_than_12_profile_pictures

  def no_more_than_12_profile_pictures
  	picture_count = TournamentProfilePicture.where(tournament_id: tournament_id).count
  	if picture_count > 11
  		errors.add(:image, "Sorry, Can't have more than 12 profile pictures")
  	end
  end
end
