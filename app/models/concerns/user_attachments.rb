# typed: ignore

module UserAttachments
  extend ActiveSupport::Concern
  include ImageUploader::Attachment(:avatar)
end
