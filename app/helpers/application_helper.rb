module ApplicationHelper
  def nav_link (link_text, path)
    class_name= current_page?(path)? 'active' : ''
    content_tag(:li, :class=> class_name) do
      link_to link_text, path
    end
  end
end
