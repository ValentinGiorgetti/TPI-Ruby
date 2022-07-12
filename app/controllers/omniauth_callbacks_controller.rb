class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        flash[:notice] = "Successfully authenticated from Google account (#{@user.email})"
        sign_in_and_redirect @user, event: :authentication
      else
        session['devise.google_data'] = request.env['omniauth.auth'].except('extra')
        redirect_to new_user_session_url, alert: @user.errors.full_messages.join("\n")
      end
  end
  
end