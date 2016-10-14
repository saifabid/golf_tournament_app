class Person < ApplicationRecord
  belongs_to :tournament

  def insert_organizer user_id
    self.user_id = user_id
    self.is_organizer = true
    self.save
    return true
  end

  def insert_person	
	self.save
	return true
  end
end
