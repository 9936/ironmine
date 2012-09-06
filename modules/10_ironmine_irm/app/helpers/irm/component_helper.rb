module Irm::ComponentHelper

  def detail_data_table(size,&block)
    if size<1
      render :partial=>"components/irm_data_table_no_data"
    else
      return capture( &block)
    end
  end
end