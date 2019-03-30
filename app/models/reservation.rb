class Reservation < ApplicationRecord
  enum status: [:confirmed, :complete, :cancelled, :blocked]
  enum purpose: [:academic, :entrepreneurship, :research, :personal]

  belongs_to :equipment
  belongs_to :user

  validates :status, :purpose, :start_time, :end_time, presence: true
  validate :date_range_valid, :not_overlapped, :date_is_available

  scope :upcoming, ->(limit) { where('start_time > ?', Time.now).order(:start_time).limit(limit) }

  def overlapped_reservations
    equipment.reservations
             .where.not(id: id)
             .where('start_time < ? AND ? < end_time', end_time, start_time)
             .where.not('status = ?', Reservation.statuses[:cancelled])
  end

  def not_overlapped
    if start_time.present? && end_time.present?
      if overlapped_reservations.exists?
        errors.add(:date, 'is overlapping with another reservation')
      end
    end
  end

  def date_in_available_range
    equipment.available_hours
             .where(day_of_week: start_time.wday)
             .where('start_time < ? AND ? < end_time', end_time.to_formatted_s(:time), start_time.to_formatted_s(:time))
  end

  def date_is_available
    if start_time.present? && end_time.present?
      unless date_in_available_range.exists?
        errors.add(:date, 'is not within the equipment available hours')
      end
    end
  end

  def remove_overlapped
    overlapped_reservations.each(&:cancelled!) # TODO: notify user of cancellation
  end

  def date_range_valid
    return if start_time.blank?

    errors.add(:start_time, "can't be in the past") if start_time < Time.now
    errors.add(:end_time, "can't be before start time") if end_time.present? && end_time < start_time
  end
end
