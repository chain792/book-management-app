# typed: true
class StaticPagesController < ApplicationController
  skip_before_action :require_authentication

  def top; end

  def terms; end

  def privacy; end
end
