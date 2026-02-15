# typed: strict

class ErrorMessageComponent < ApplicationComponent
  sig { params(object: T.untyped).void }
  def initialize(object:)
    @object = object
  end

  sig { returns(T::Boolean) }
  def render?
    object.errors.any?
  end

  private

  sig { returns(T.untyped) }
  attr_reader :object
end
