module ApplicationHelper
  def render_page_title
    site_name = Settings.site_name
    title = @page_title ? "#{@page_title} - #{site_name}" : site_name
    content_tag('title', title, nil, false)
  end
end
