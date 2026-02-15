# typed: true
class StaticPagesController < ApplicationController
  extend T::Sig

  allow_unauthenticated_access

  sig { void }
  def top; end

  sig { void }
  def terms; end

  sig { void }
  def privacy; end
end
