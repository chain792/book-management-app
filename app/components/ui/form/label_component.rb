# typed: strict

module Ui
  module Form
    class LabelComponent < ApplicationComponent
      sig { params(form: ActionView::Helpers::FormBuilder, field: Symbol, text: T.nilable(String), class_names: T.nilable(String), options: T.untyped).void }
      def initialize(form:, field:, text: nil, class_names: nil, **options)
        @form = form
        @field = field
        @text = text
        @class_names = class_names
        @options = options
      end

      private

      sig { returns(ActionView::Helpers::FormBuilder) }
      attr_reader :form

      sig { returns(Symbol) }
      attr_reader :field
    end
  end
end
