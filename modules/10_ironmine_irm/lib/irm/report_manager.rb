module Irm
  module ReportManager
    class << self
      def add_report(klass)
        raise "Report must include Singleton module." unless klass.included_modules.include?(Singleton)
        report_classes = Ironmine::STORAGE.get(:report_classes)||[]
        report_classes << klass
        Ironmine::STORAGE.put(:report_classes,report_classes)
      end

      # Clears all the reports.
      def clear_reports
        Ironmine::STORAGE.put(:report_classes,[])
      end

      def report_classes
        Ironmine::STORAGE.get(:report_classes)||[]
      end


      def report_instance(report_name)
        report_class = report_classes.detect{|i| i.name.eql?(report_name)}
        report_class.instance if report_class
      end

    end

    class ReportBase
      include Singleton

      attr_accessor_with_default :partial_base_path,"reports"

      def self.inherited(child)
        Irm::ReportManager.add_report(child)
        super
      end

      # 根据传入的报表参数,取得报表数据
      def data(params={})
        {:datas=>[],:params=>params}
      end

      # 导出excel
      def to_xls(params={})

      end

      # 报表运行页面的参数模板
      def params_partial
        "#{partial_base_path}/#{self.class.name.underscore}/params"
      end

      # 报表结果显示模板
      def partial
        "#{partial_base_path}/#{self.class.name.underscore}/html"
      end

      # 报表的email模板
      def mail_partial
        "#{partial_base_path}/#{self.class.name.underscore}/mail"
      end

      def name
         self.class.name.underscore
      end

      def description
        "Report:#{self.class.name.underscore}"
      end

    end
  end
end