module DirectivesHelper
  def truncate(str, n=20)
    if str.size > n
      str[0..20] + "..."
    else
      str
    end
  end

  def star_html(did, star_on = true)
    switch_html("star", did, star_directive_path(did), unstar_directive_path(did), star_on)
  end

  def flag_html(did, flag_on = true)
    switch_html("flag", did, flag_directive_path(did), unflag_directive_path(did), flag_on)
  end

  def switch_html(kind, did, off_path, on_path, switch_on)
    if switch_on
      link_to_function image_tag("#{kind}.ico"), "un#{kind}('#{on_path}', #{did})"      
    else
      link_to_function image_tag("un#{kind}.ico"), "#{kind}('#{off_path}', #{did})"
    end
  end  

  def name_and_role(user)
    [user.name, user.occupation].compact.join(", ")
  end

end
