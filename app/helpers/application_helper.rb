module ApplicationHelper

  def baccalaureat_breaked(baccalaureat)
    baccalaureat.to_s.gsub(' / ', '<br>/ ').html_safe
  end
end
