# typed: strict

module Authentication
  extend T::Sig
  extend T::Helpers
  extend ActiveSupport::Concern

  requires_ancestor { ActionController::Base }
  requires_ancestor { GeneratedPathHelpersModule }
  requires_ancestor { GeneratedUrlHelpersModule }

  included do
    T.bind(self, T.class_of(ActionController::Base))
    before_action :require_authentication
    helper_method :authenticated?
    helper_method :current_user
  end

  module ClassMethods
    extend T::Sig
    sig { params(options: T.untyped).void }
    def allow_unauthenticated_access(**options)
      T.unsafe(self).skip_before_action :require_authentication, **options
    end
  end

  private
    sig { returns(T::Boolean) }
    def authenticated?
      resume_session.present?
    end

    sig { returns(T.nilable(Session)) }
    def require_authentication
      resume_session || request_authentication
    end

    sig { returns(T.nilable(Session)) }
    def resume_session
      Current.session ||= find_session_by_cookie
    end

    sig { returns(T.nilable(Session)) }
    def find_session_by_cookie
      T.bind(self, ActionController::Base)
      if session_id = cookies.signed[:session_id]
        Session.find_by(id: session_id)
      end
    end

    sig { returns(T.nilable(Session)) }
    def request_authentication
      T.bind(self, ActionController::Base)
      T.unsafe(self).session[:return_to_after_authenticating] = request.url
      T.unsafe(self).redirect_to T.unsafe(self).login_path, warning: "ログインしてください"
      nil
    end

    sig { returns(T.any(String, T.untyped)) }
    def after_authentication_url
      T.bind(self, ActionController::Base)
      T.unsafe(self).session.delete(:return_to_after_authenticating) || T.unsafe(self).root_url
    end

    sig { params(user: User).returns(Session) }
    def start_new_session_for(user)
      T.bind(self, ActionController::Base)
      user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
        Current.session = session
        cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }
      end
    end

    sig { void }
    def terminate_session
      T.bind(self, ActionController::Base)
      Current.session&.destroy
      cookies.delete(:session_id)
    end

    sig { returns(T.nilable(User)) }
    def current_user
      resume_session
      Current.session&.user
    end

    sig { returns(User) }
    def current_user!
      T.must(current_user)
    end
end
