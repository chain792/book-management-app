# typed: strict

module Ui
  module Form
    class SelectComponent < ApplicationComponent
      sig {
        params(
          form: ActionView::Helpers::FormBuilder,
          field: Symbol,
          choices: T.untyped,
          options: T::Hash[Symbol, T.untyped],
          html_options: T.untyped
        ).void
      }
      def initialize(form:, field:, choices:, options: {}, **html_options)
        @form = form
        @field = field
        @choices = choices
        @options = options
        @html_options = html_options
      end

      private

      sig { returns(ActionView::Helpers::FormBuilder) }
      attr_reader :form

      sig { returns(Symbol) }
      attr_reader :field

      sig { returns(String) }
      def base_classes
        "w-full bg-brand-50/50 border-2 border-brand-100 rounded-2xl px-6 py-4 font-bold text-brand-900 focus:bg-white focus:border-brand-500 focus:ring-4 focus:ring-brand-100 focus:outline-none transition-all cursor-pointer appearance-none"
      end
    end
  end
end
