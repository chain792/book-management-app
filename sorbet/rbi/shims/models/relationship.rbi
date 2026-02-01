# typed: strict

class Relationship
  sig { returns(::User) }
  def follower; end

  sig { returns(::User) }
  def followed; end
end
