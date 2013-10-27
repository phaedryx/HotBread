module ApplicationHelper
  def flash_class(level)
    case level
      when :warning then "alert-box radius"
      when :notice  then "alert-box radius"
      when :success then "alert-box radius success"
      when :error   then "alert-box radius alert"
      when :alert   then "alert-box radius alert"
      else "alert-box radius"
    end
  end

  def flash_icon(level)
    case level
      when :warning then "fi-alert"
      when :notice  then "fi-check"
      when :success then "fi-check"
      when :error   then "fi-alert"
      when :alert   then "fi-alert"
      else "fi-check"
    end
  end
end
