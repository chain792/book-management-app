# typed: strict

module Layout
  class FlashComponent < ApplicationComponent
    sig { params(flash: ActionDispatch::Flash::FlashHash).void }
    def initialize(flash:)
      @flash = flash
    end

    private

    sig { returns(ActionDispatch::Flash::FlashHash) }
    attr_reader :flash
  end
end
