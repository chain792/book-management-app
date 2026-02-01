# typed: strict

class Current < ActiveSupport::CurrentAttributes
  sig { returns(T.nilable(Session)) }
  def self.session; end

  sig { params(value: T.nilable(Session)).returns(T.nilable(Session)) }
  def self.session=(value); end

  sig { params(args: T.untyped, kwargs: T.untyped, block: T.nilable(T.proc.params(object: T.untyped).void)).returns(T.nilable(User)) }
  def self.user(*args, **kwargs, &block); end
end
