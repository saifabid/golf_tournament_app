json.array!(@venue) do |venue|
	json.name		venue.name
	json.address	venue.address
	json.website	venue.website
	json.contact	venue.contact
end