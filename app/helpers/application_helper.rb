# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title
    return @title if @title
    base = "Art Directives Database"
    if @page_title
      base + ": " + @page_title
    else
      base
    end
  end

  def date_str(datetime)
    datetime.in_time_zone("Pacific Time (US & Canada)").strftime("%D")
  end
end
