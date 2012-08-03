require 'uuid'
module Fwk
  class IdGenerator
    include Singleton
    def decimal_to_62(decimal)
      result = ""
      number = decimal
      while(number>0)
        s = number%62
        if s>35
          s = (s+61).chr
        elsif s>9
          s = (s+55).chr
        end
        result << s.to_s
        number = (number/62).to_i
      end
      result.reverse
    end

    def rjust_decimal_to_62(decimal,length=4)
      result = decimal_to_62(decimal)
      result.rjust(length,"0")
    end

    def uuid_to_62(uuid)
      custom_uuid = uuid[0..(uuid.rindex("-")-1)]
      number = custom_uuid.split("-").reverse.join("").hex
      rjust_decimal_to_62(number,14)
    end

    def uuid_generator
      @uuid_generator ||= UUID.new
    end

    def generate(table_name)
      [Irm::ObjectCode.code(table_name),Irm::MachineCode.current,uuid_to_62(uuid_generator.generate)].join("")
    end
  end
end