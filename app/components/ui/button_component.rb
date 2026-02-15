# typed: strict

module Ui
  class ButtonComponent < ApplicationComponent
    sig {
      params(
        variant: String,
        size: String,
        type: String,
        class_names: T.nilable(String),
        options: T.untyped
      ).void
    }
    def initialize(variant: "primary", size: "md", type: "button", class_names: nil, **options)
      @variant = variant
      @size = size
      @type = type
      @class_names = class_names
      @options = options
    end

    private

    sig { returns(String) }
    def variant_classes
      case @variant
      when "primary"
        "btn-primary"
      when "secondary"
        "btn-secondary"
      when "danger"
        "bg-rose-500 text-white hover:bg-rose-600 shadow-rose-500/20 px-8 py-3 rounded-full font-black text-sm tracking-wider shadow-lg transition-all duration-300"
      else
        "btn-primary"
      end
    end

    sig { returns(String) }
    def size_classes
      case @size
      when "sm"
        "px-4 py-2 text-xs"
      when "md"
        "" # Default in btn-primary/secondary
      when "lg"
        "px-10 py-4 text-base"
      else
        ""
      end
    end

    sig { returns(String) }
    def type
      @type
    end
  end
end
