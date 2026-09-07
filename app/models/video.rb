class Video < ApplicationRecord
  ALLOWED_CONTENT_TYPES = %w[
    video/mp4
    video/quicktime
    video/webm
    video/x-matroska
    video/x-msvideo
  ].freeze

  MAX_FILE_SIZE = 2.gigabytes

  has_one_attached :file

  validate :file_attached
  validate :allowed_content_type, if: -> { file.attached? }
  validate :acceptable_file_size, if: -> { file.attached? }

  private
    def file_attached
      errors.add(:file, :blank) unless file.attached?
    end

    def allowed_content_type
      return if file.content_type.in?(ALLOWED_CONTENT_TYPES)

      errors.add(:file, :invalid_format)
    end

    def acceptable_file_size
      return if file.byte_size <= MAX_FILE_SIZE

      errors.add(:file, :too_large, max_size: number_to_human_size(MAX_FILE_SIZE))
    end

    def number_to_human_size(bytes)
      ActiveSupport::NumberHelper.number_to_human_size(bytes)
    end
end
