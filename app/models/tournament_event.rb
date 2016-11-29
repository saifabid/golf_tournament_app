class TournamentEvent < ApplicationRecord
  belongs_to :tournament
  validates_presence_of :event_name
  validate :start_time_before_end_time,

  def start_time_before_end_time
    if start_time > end_time
      errors.add(:start_time, "can't be after the end time")
    end
  end
end
