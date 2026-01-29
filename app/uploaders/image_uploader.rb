class ImageUploader < Shrine
  plugin :validation_helpers

  Attacher.validate do
    validate_max_size 5 * 1024 * 1024, message: "は5MB以下にしてください"
    validate_mime_type %w[image/jpeg image/png image/webp]
  end
end
