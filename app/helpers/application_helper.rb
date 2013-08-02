module ApplicationHelper
	def flash_class(type)
		case type
			when :notice
        'alert-success'
			when :alert
        'alert-error'
			else
        ''
		end		
  end

  def avatar_profile_link(user, image_options={class: 'img-circle'}, html_options={})
    link_to image_tag(user.avatar? ? user.avatar.url(:thumb) : nil, image_options), profile_path(user.profile_name), html_options
  end

  def page_header(&block)
    content_tag(:div, capture(&block), class: 'page-header')
  end

end
