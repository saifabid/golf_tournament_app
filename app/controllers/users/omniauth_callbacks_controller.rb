class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @vars = request.env["omniauth.auth"]
    @user = User.from_omniauth(@vars)

    if @user.persisted?
      @account = Account.new
      @account.user_id = @user.id
      @user.account_id = @account.id
      @account.first_name = @vars.info.name.partition(' ')[0]
      @account.last_name = @vars.info.name.partition(' ')[2]
      @account.profile_pic = @vars.info.image
      @account.birth = Date.new(2001,2,3)
      @account.save
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def linkedin
    @vars = request.env["omniauth.auth"]
    @user = User.from_omniauth(@vars)

     if @user.persisted?
      @account = Account.new
      @account.user_id = @user.id
      @user.account_id = @account.id
      @account.first_name = @vars.info.name.partition(' ')[0]
      @account.last_name = @vars.info.name.partition(' ')[2]
      @account.profile_pic = @vars.info.image
      @account.birth = Date.new(2001,2,3)
      @account.save
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "linkedin") if is_navigational_format?
    else
      session["devise.linkedin_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end

  end

  def failure
    redirect_to root_path
  end

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
