module ApplicationHelper
  def flash_class(level)
    case level
    when :success then "success"
    when :error then "error"
    when :info then "info"
    end
  end
end
