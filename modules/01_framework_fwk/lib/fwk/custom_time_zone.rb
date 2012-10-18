module Fwk
  class CustomTimeZone
    MAPPING = {
        :GMT_M0100=>"Cape Verde Is.",
        :GMT_M0200=>"Mid-Atlantic",
        :GMT_M0300=>"Buenos Aires",
        :GMT_M0300_2=>"Brasilia",
        :GMT_M0330=>"Newfoundland",
        :GMT_M0400=>"Atlantic Time (Canada)",
        :GMT_M0400_2=>"Caracas",
        :GMT_M0400_3=>"Santiago",
        :GMT_M0400_4=>"La Paz",
        :GMT_M0430=>"Caracas",
        :GMT_M0500=>"Bogota",
        :GMT_M0500_2=>"Lima",
        :GMT_M0500_3=>"Quito",
        :GMT_M0500_4=>"Eastern Time (US & Canada)",
        :GMT_M0500_5=>"Indiana (East)",
        :GMT_M0600=>"Central Time (US & Canada)",
        :GMT_M0600_2=>"Guadalajara",
        :GMT_M0600_3=>"Mexico City",
        :GMT_M0700=>"Mountain Time (US & Canada)",
        :GMT_M0700_2=>"Arizona",
        :GMT_M0800=>"Pacific Time (US & Canada)",
        :GMT_M0800_2=>"Tijuana",
        :GMT_M0900=>"Alaska",
        :GMT_M1000=>"Hawaii",
        :GMT_M1100=>"Hawaii",
        :GMT_M1100_2=>"Samoa",
        :GMT_P0000=>"Dublin",
        :GMT_P0000_2=>"Lisbon",
        :GMT_P0000_3=>"London",
        :GMT_P0000_4=>"Casablanca",
        :GMT_P0100=>"Amsterdam",
        :GMT_P0100_2=>"Bern",
        :GMT_P0100_3=>"Brussels",
        :GMT_P0100_4=>"Paris",
        :GMT_P0100_5=>"Prague",
        :GMT_P0100_6=>"Rome",
        :GMT_P0200=>"Cairo",
        :GMT_P0200_2=>"Pretoria",
        :GMT_P0200_3=>"Jerusalem",
        :GMT_P0200_4=>"Athens",
        :GMT_P0200_5=>"Bucharest",
        :GMT_P0200_6=>"Helsinki",
        :GMT_P0200_7=>"Istanbul",
        :GMT_P0200_8=>"Minsk",
        :GMT_P0300=>"Nairobi",
        :GMT_P0300_2=>"Baghdad",
        :GMT_P0300_3=>"Kuwait",
        :GMT_P0300_4=>"Riyadh",
        :GMT_P0300_5=>"Volgograd",
        :GMT_P0330=>"Tehran",
        :GMT_P0400=>"Moscow",
        :GMT_P0400_2=>"Tbilisi",
        :GMT_P0430=>"Kabul",
        :GMT_P0500=>"Karachi",
        :GMT_P0500_2=>"Tashkent",
        :GMT_P0500_3=>"Islamabad",
        :GMT_P0530=>"New Delhi",
        :GMT_P0530_2=>"Sri Jayawardenepura",
        :GMT_P0545=>"Kathmandu",
        :GMT_P0600=>"Dhaka",
        :GMT_P0630=>"Rangoon",
        :GMT_P0700=>"Hanoi",
        :GMT_P0700_2=>"Jakarta",
        :GMT_P0700_3=>"Bangkok",
        :GMT_P0800=>"Hong Kong",
        :GMT_P0800_2=>"Kuala Lumpur",
        :GMT_P0800_3=>"Chongqing",
        :GMT_P0800_4=>"Beijing",
        :GMT_P0800_5=>"Singapore",
        :GMT_P0800_6=>"Taipei",
        :GMT_P0800_7=>"Perth",
        :GMT_P0900=>"Seoul",
        :GMT_P0900_2=>"Tokyo",
        :GMT_P0930=>"Adelaide",
        :GMT_P0930_2=>"Darwin",
        :GMT_P1000=>"Brisbane",
        :GMT_P1000_2=>"Sydney",
        :GMT_P1030=>"New Caledonia",
        :GMT_P1100=>"Vladivostok",
        :GMT_P1130=>"Magadan",
        :GMT_P1200=>"Kamchatka",
        :GMT_P1200_2=>"Wellington",
        :GMT_P1200_3=>"Fiji",
        :GMT_P1245=>"Nuku'alofa",
        :GMT_P1300=>"Marshall Is.",
        :GMT_P1300_2=>"Nuku'alofa",
        :GMT_P1400=>"Auckland"
    }
    def self.value_to_name(value)
      MAPPING[value.to_sym]
    end



    #    =======================International Date Line West:(GMT-11:00) International Date Line West=============
    #    =======================Midway Island:(GMT-11:00) Midway Island=============
    #    =======================Samoa:(GMT-11:00) Samoa=============
    #    =======================Hawaii:(GMT-10:00) Hawaii=============
    #    =======================Alaska:(GMT-09:00) Alaska=============
    #    =======================Pacific Time (US & Canada):(GMT-08:00) Pacific Time (US & Canada)=============
    #    =======================Tijuana:(GMT-08:00) Tijuana=============
    #    =======================Mountain Time (US & Canada):(GMT-07:00) Mountain Time (US & Canada)=============
    #    =======================Arizona:(GMT-07:00) Arizona=============
    #    =======================Chihuahua:(GMT-07:00) Chihuahua=============
    #    =======================Mazatlan:(GMT-07:00) Mazatlan=============
    #    =======================Central Time (US & Canada):(GMT-06:00) Central Time (US & Canada)=============
    #    =======================Saskatchewan:(GMT-06:00) Saskatchewan=============
    #    =======================Guadalajara:(GMT-06:00) Guadalajara=============
    #    =======================Mexico City:(GMT-06:00) Mexico City=============
    #    =======================Monterrey:(GMT-06:00) Monterrey=============
    #    =======================Central America:(GMT-06:00) Central America=============
    #    =======================Eastern Time (US & Canada):(GMT-05:00) Eastern Time (US & Canada)=============
    #    =======================Indiana (East):(GMT-05:00) Indiana (East)=============
    #    =======================Bogota:(GMT-05:00) Bogota=============
    #    =======================Lima:(GMT-05:00) Lima=============
    #    =======================Quito:(GMT-05:00) Quito=============
    #    =======================Atlantic Time (Canada):(GMT-04:00) Atlantic Time (Canada)=============
    #    =======================Caracas:(GMT-04:30) Caracas=============
    #    =======================La Paz:(GMT-04:00) La Paz=============
    #    =======================Santiago:(GMT-04:00) Santiago=============
    #    =======================Newfoundland:(GMT-03:30) Newfoundland=============
    #    =======================Brasilia:(GMT-03:00) Brasilia=============
    #    =======================Buenos Aires:(GMT-03:00) Buenos Aires=============
    #    =======================Georgetown:(GMT-04:00) Georgetown=============
    #    =======================Greenland:(GMT-03:00) Greenland=============
    #    =======================Mid-Atlantic:(GMT-02:00) Mid-Atlantic=============
    #    =======================Azores:(GMT-01:00) Azores=============
    #    =======================Cape Verde Is.:(GMT-01:00) Cape Verde Is.=============
    #    =======================Dublin:(GMT+00:00) Dublin=============
    #    =======================Edinburgh:(GMT+00:00) Edinburgh=============
    #    =======================Lisbon:(GMT+00:00) Lisbon=============
    #    =======================London:(GMT+00:00) London=============
    #    =======================Casablanca:(GMT+00:00) Casablanca=============
    #    =======================Monrovia:(GMT+00:00) Monrovia=============
    #    =======================UTC:(GMT+00:00) UTC=============
    #    =======================Belgrade:(GMT+01:00) Belgrade=============
    #    =======================Bratislava:(GMT+01:00) Bratislava=============
    #    =======================Budapest:(GMT+01:00) Budapest=============
    #    =======================Ljubljana:(GMT+01:00) Ljubljana=============
    #    =======================Prague:(GMT+01:00) Prague=============
    #    =======================Sarajevo:(GMT+01:00) Sarajevo=============
    #    =======================Skopje:(GMT+01:00) Skopje=============
    #    =======================Warsaw:(GMT+01:00) Warsaw=============
    #    =======================Zagreb:(GMT+01:00) Zagreb=============
    #    =======================Brussels:(GMT+01:00) Brussels=============
    #    =======================Copenhagen:(GMT+01:00) Copenhagen=============
    #    =======================Madrid:(GMT+01:00) Madrid=============
    #    =======================Paris:(GMT+01:00) Paris=============
    #    =======================Amsterdam:(GMT+01:00) Amsterdam=============
    #    =======================Berlin:(GMT+01:00) Berlin=============
    #    =======================Bern:(GMT+01:00) Bern=============
    #    =======================Rome:(GMT+01:00) Rome=============
    #    =======================Stockholm:(GMT+01:00) Stockholm=============
    #    =======================Vienna:(GMT+01:00) Vienna=============
    #    =======================West Central Africa:(GMT+01:00) West Central Africa=============
    #    =======================Bucharest:(GMT+02:00) Bucharest=============
    #    =======================Cairo:(GMT+02:00) Cairo=============
    #    =======================Helsinki:(GMT+02:00) Helsinki=============
    #    =======================Kyiv:(GMT+02:00) Kyiv=============
    #    =======================Riga:(GMT+02:00) Riga=============
    #    =======================Sofia:(GMT+02:00) Sofia=============
    #    =======================Tallinn:(GMT+02:00) Tallinn=============
    #    =======================Vilnius:(GMT+02:00) Vilnius=============
    #    =======================Athens:(GMT+02:00) Athens=============
    #    =======================Istanbul:(GMT+02:00) Istanbul=============
    #    =======================Minsk:(GMT+03:00) Minsk=============
    #    =======================Jerusalem:(GMT+02:00) Jerusalem=============
    #    =======================Harare:(GMT+02:00) Harare=============
    #    =======================Pretoria:(GMT+02:00) Pretoria=============
    #    =======================Moscow:(GMT+04:00) Moscow=============
    #    =======================St. Petersburg:(GMT+04:00) St. Petersburg=============
    #    =======================Volgograd:(GMT+04:00) Volgograd=============
    #    =======================Kuwait:(GMT+03:00) Kuwait=============
    #    =======================Riyadh:(GMT+03:00) Riyadh=============
    #    =======================Nairobi:(GMT+03:00) Nairobi=============
    #    =======================Baghdad:(GMT+03:00) Baghdad=============
    #    =======================Tehran:(GMT+03:30) Tehran=============
    #    =======================Abu Dhabi:(GMT+04:00) Abu Dhabi=============
    #    =======================Muscat:(GMT+04:00) Muscat=============
    #    =======================Baku:(GMT+04:00) Baku=============
    #    =======================Tbilisi:(GMT+04:00) Tbilisi=============
    #    =======================Yerevan:(GMT+04:00) Yerevan=============
    #    =======================Kabul:(GMT+04:30) Kabul=============
    #    =======================Ekaterinburg:(GMT+06:00) Ekaterinburg=============
    #    =======================Islamabad:(GMT+05:00) Islamabad=============
    #    =======================Karachi:(GMT+05:00) Karachi=============
    #    =======================Tashkent:(GMT+05:00) Tashkent=============
    #    =======================Chennai:(GMT+05:30) Chennai=============
    #    =======================Kolkata:(GMT+05:30) Kolkata=============
    #    =======================Mumbai:(GMT+05:30) Mumbai=============
    #    =======================New Delhi:(GMT+05:30) New Delhi=============
    #    =======================Kathmandu:(GMT+05:45) Kathmandu=============
    #    =======================Astana:(GMT+06:00) Astana=============
    #    =======================Dhaka:(GMT+06:00) Dhaka=============
    #    =======================Sri Jayawardenepura:(GMT+05:30) Sri Jayawardenepura=============
    #    =======================Almaty:(GMT+06:00) Almaty=============
    #    =======================Novosibirsk:(GMT+07:00) Novosibirsk=============
    #    =======================Rangoon:(GMT+06:30) Rangoon=============
    #    =======================Bangkok:(GMT+07:00) Bangkok=============
    #    =======================Hanoi:(GMT+07:00) Hanoi=============
    #    =======================Jakarta:(GMT+07:00) Jakarta=============
    #    =======================Krasnoyarsk:(GMT+08:00) Krasnoyarsk=============
    #    =======================Beijing:(GMT+08:00) Beijing=============
    #    =======================Chongqing:(GMT+08:00) Chongqing=============
    #    =======================Hong Kong:(GMT+08:00) Hong Kong=============
    #    =======================Urumqi:(GMT+08:00) Urumqi=============
    #    =======================Kuala Lumpur:(GMT+08:00) Kuala Lumpur=============
    #    =======================Singapore:(GMT+08:00) Singapore=============
    #    =======================Taipei:(GMT+08:00) Taipei=============
    #    =======================Perth:(GMT+08:00) Perth=============
    #    =======================Irkutsk:(GMT+09:00) Irkutsk=============
    #    =======================Ulaan Bataar:(GMT+08:00) Ulaan Bataar=============
    #    =======================Seoul:(GMT+09:00) Seoul=============
    #    =======================Osaka:(GMT+09:00) Osaka=============
    #    =======================Sapporo:(GMT+09:00) Sapporo=============
    #    =======================Tokyo:(GMT+09:00) Tokyo=============
    #    =======================Yakutsk:(GMT+10:00) Yakutsk=============
    #    =======================Darwin:(GMT+09:30) Darwin=============
    #    =======================Adelaide:(GMT+09:30) Adelaide=============
    #    =======================Canberra:(GMT+10:00) Canberra=============
    #    =======================Melbourne:(GMT+10:00) Melbourne=============
    #    =======================Sydney:(GMT+10:00) Sydney=============
    #    =======================Brisbane:(GMT+10:00) Brisbane=============
    #    =======================Hobart:(GMT+10:00) Hobart=============
    #    =======================Vladivostok:(GMT+11:00) Vladivostok=============
    #    =======================Guam:(GMT+10:00) Guam=============
    #    =======================Port Moresby:(GMT+10:00) Port Moresby=============
    #    =======================Magadan:(GMT+12:00) Magadan=============
    #    =======================Solomon Is.:(GMT+12:00) Solomon Is.=============
    #    =======================New Caledonia:(GMT+11:00) New Caledonia=============
    #    =======================Fiji:(GMT+12:00) Fiji=============
    #    =======================Kamchatka:(GMT+12:00) Kamchatka=============
    #    =======================Marshall Is.:(GMT+12:00) Marshall Is.=============
    #    =======================Auckland:(GMT+12:00) Auckland=============
    #    =======================Wellington:(GMT+12:00) Wellington=============
    #    =======================Nuku'alofa:(GMT+13:00) Nuku'alofa=============


    def build_mapping
      I18n.locale = :zh
      rails_time_zones = ActiveSupport::TimeZone::MAPPING
      #将HASH的key 和 value 值交换
      rails_time_zones = rails_time_zones.invert
      gmt_time_zones = Irm::LookupValue.query_by_lookup_type("TIMEZONE").multilingual.collect{|m| [m[:meaning], m.lookup_code]}
      gmt_time_zones.each do |time_zone|
        value = /([a-zA-Z|\/|_]+)/.match(time_zone[0])
        MAPPING[time_zone[1].to_sym] = rails_time_zones[value[1]]
      end
      puts "================#{MAPPING}======================"
    end


    def get_en_meaning
      ActiveSupport::TimeZone::MAPPING.each do |k, v|
        puts "\"#{k}\": #{k}(#{v})"
      end
    end

    def get_zh_meaning
      I18n.locale = :zh
      lookup_zones = Irm::LookupValue.query_by_lookup_type("TIMEZONE").multilingual.index_by(&:lookup_code)
      mapping = MAPPING.invert

      rails_time_zones = ActiveSupport::TimeZone::MAPPING
      rails_time_zones.each do |k,v|
        if mapping[k.to_s].present?
          name = lookup_zones[mapping[k].to_s][:meaning]
        else
          name = k
        end
        puts "\"#{k}\": #{name}(#{v})"
      end
    end

  end
end