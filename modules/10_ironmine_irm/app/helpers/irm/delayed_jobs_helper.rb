module Irm::DelayedJobsHelper
  def data_with_style(datas)
    if datas and datas.any?
      datas.each do |data|
        case data[:job_status]
          when 'ENQUEUE'

          when 'DESTROY'

          when 'ERROR'
            data[:background_color] = '#f2dede'
            data[:color] = '#b94a48'
          when 'RUN'

          else

        end
      end
    end
  end
end