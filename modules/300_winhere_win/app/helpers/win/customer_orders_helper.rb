module Win::CustomerOrdersHelper
  def display_color(success_flag)
    bg_color = "green"
    if "N".eql?(success_flag)
      bg_color = "red"
    end
    bg_color
  end

end