class ApplicationController < ActionController::Base
  # deviceのコントローラーのときに、下記のメソッドを呼ぶ
  before_action :configure_permitted_parameters, if: :devise_controller?

  def authenticate
    redirect_to login_url unless user_signed_in?
  end

  protected

  def configure_permitted_parameters
    added_attrs = [:account_name, :email, :password, :password_confirmation, :remember_me, :accepted, :birth_date]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  private

  def admin_user
    redirect_to new_admin_session_url unless admin_signed_in?
  end

  def record_params
    params.require(:record).
      permit(:date, :m_sbp, :m_dbp, :m_pulse, :n_sbp, :n_dbp, :n_pulse, :memo,).
      merge(user_id: current_user.id)
  end
end
