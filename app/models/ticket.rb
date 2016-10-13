class Ticket < ApplicationRecord
	def register
		self.save
		return true
	end
end