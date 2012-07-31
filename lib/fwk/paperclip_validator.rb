module Fwk::PaperclipValidator

  def self.included base
    base.class_eval do

      # Places ActiveRecord-style validations on the size of the file assigned. The
      # possible options are:
      # * +in+: a Range of bytes (i.e. +1..1.megabyte+),
      # * +less_than+: equivalent to :in => 0..options[:less_than]
      # * +greater_than+: equivalent to :in => options[:greater_than]..Infinity
      # * +message+: error message to display, use :min and :max as replacements
      # * +if+: A lambda or name of a method on the instance. Validation will only
      #   be run is this lambda or method returns true.
      # * +unless+: Same as +if+ but validates if lambda or method returns false.
      def validates_attachment_size name, options = {}
        min     = options[:greater_than] || (options[:in] && options[:in].first) || 0
        max     = options[:less_than]    || (options[:in] && options[:in].last)  || (1.0/0)
        range   = (0..(1.0/0))
        if min.respond_to?(:call)&&max.respond_to?(:call)
          range   = Proc.new{|i| (min.call..max.call) }
        elsif min.respond_to?(:call)
          range   = Proc.new{|i| (min.call..max) }
        elsif max.respond_to?(:call)
          range   = Proc.new{|i| (min..max.call) }
        else
          range   = (min..max)
        end

        message = options[:message] || "file size must be between :min and :max bytes"
        message = message.call if message.respond_to?(:call)
        message = message.gsub(/:min/, min.to_s).gsub(/:max/, max.to_s)

        validates_inclusion_of :"#{name}_file_size",
                               :in        => range,
                               :message   => message,
                               :if        => options[:if],
                               :unless    => options[:unless],
                               :allow_nil => true
      end
    end
  end
end