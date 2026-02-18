# typed: strict

module Layout
  class FooterComponent < ApplicationComponent
    sig { void }
    def initialize
    end

    private

    sig { returns(Integer) }
    def current_year
      Time.zone.now.year
    end
  end
end
