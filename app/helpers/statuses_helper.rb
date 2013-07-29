module StatusesHelper
  def can_display_status?(status)
    signed_in? and !current_user.has_blocked? status.user or !signed_in?
  end
end
