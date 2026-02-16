# typed: true
class StaticPagesController < ApplicationController
  extend T::Sig

  allow_unauthenticated_access

  def top; end

  def terms; end

  def privacy; end
end
