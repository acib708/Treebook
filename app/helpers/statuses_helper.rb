module StatusesHelper
  def display_attachment(status, with_hr=true)
    if status.document and status.document.attachment?
      html = ''
      html << content_tag(:span, 'Attachment', class: 'label label-info')
      html << link_to(" #{status.document.attachment_file_name}", status.document.attachment.url)
      html << content_tag(:hr) if with_hr
      html.html_safe
    end
  end

  def can_display_status?(status)
    signed_in? and !current_user.has_blocked? status.user or !signed_in?
  end
end
