# typed: strict

module Ui
  module Form
    class TextAreaComponent < ApplicationComponent
      sig {
        params(
          form: ActionView::Helpers::FormBuilder,
          field: Symbol,
          placeholder: T.nilable(String),
          rows: Integer,
          class_names: T.nilable(String),
          options: T.untyped
        ).void
      }
      def initialize(form:, field:, placeholder: nil, rows: 4, class_names: nil, **options)
        @form = form
        @field = field
        @placeholder = placeholder
        @rows = rows
        @class_names = class_names
        @options = options
      end

      private

      sig { returns(ActionView::Helpers::FormBuilder) }
      attr_reader :form

      sig { returns(Symbol) }
      attr_reader :field

      sig { returns(String) }
      def base_classes
        "w-full bg-brand-50/50 border-2 border-brand-100 rounded-2xl px-6 py-4 font-bold text-brand-900 focus:bg-white focus:border-brand-500 focus:ring-4 focus:ring-brand-100 focus:outline-none transition-all placeholder:text-brand-200 leading-relaxed"
      end
    end
  end
end
