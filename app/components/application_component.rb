# typed: strict

class ApplicationComponent < ViewComponent::Base
  extend T::Sig
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::RecordIdentifier

  # Base component for all view components in the application.
  # Add common logic or helper inclusions here.
end
