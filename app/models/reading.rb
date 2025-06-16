class Reading < ApplicationRecord
  belongs_to :club

  validates :title, presence: true
  validates :author, presence: true
  validates :total_pages, presence: true, numericality: { greater_than: 0 }
  validates :start_date, presence: true
  validates :end_date, presence: true

  validate :end_date_after_start_date
  validate :only_one_current_reading_per_club

  scope :current, -> { where(current_reading: true) }

  private

  def end_date_after_start_date
    return unless start_date && end_date

    if end_date < start_date
      errors.add(:end_date, "deve ser posterior à data de início")
    end
  end

  def only_one_current_reading_per_club
    return unless current_reading && club_id

    existing = club.readings.where(current_reading: true)
    existing = existing.where.not(id: id) if persisted?

    if existing.exists?
      errors.add(:current_reading, "já existe um livro atual para este clube")
    end
  end
end
