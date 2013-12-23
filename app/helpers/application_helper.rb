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
      when :warning then "fa fa-exclamation-circle"
      when :notice  then "fa fa-exclamation"
      when :success then "fa fa-check"
      when :error   then "fa fa-exclamation-triangle"
      when :alert   then "fa fa-exclamation-triangle"
      else "fa fa-times-circle"
    end
  end
end
