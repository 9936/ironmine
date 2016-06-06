module Yan::WorkloadRegisterHelper

  #xheditor编辑器
  def new_xheditor(textarea_id,force_fit_width=false,shortcuts = false)
    unless limit_device?
      require_jscss(:xheditor)
      render :partial=>"yan/helper/xheditor",:locals=>{:textarea_id=>textarea_id,:force_fit_width=>force_fit_width, :shortcuts => shortcuts}
    end
  end
end
