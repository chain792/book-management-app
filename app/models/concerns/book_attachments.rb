# typed: ignore

module BookAttachments
  extend ActiveSupport::Concern
  include ImageUploader::Attachment(:book_image)
end
