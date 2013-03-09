#require 'uri/common'
#
#module URI
#  TBLDECWWWCOMP_ = {} unless const_defined?(:TBLDECWWWCOMP_)  #:nodoc:
#  if TBLDECWWWCOMP_.empty?
#    256.times do |i|
#      h, l = i>>4, i&15
#      TBLDECWWWCOMP_['%%%X%X' % [h, l]] = i.chr
#      TBLDECWWWCOMP_['%%%x%X' % [h, l]] = i.chr
#      TBLDECWWWCOMP_['%%%X%x' % [h, l]] = i.chr
#      TBLDECWWWCOMP_['%%%x%x' % [h, l]] = i.chr
#    end
#    TBLDECWWWCOMP_['+'] = ' '
#    TBLDECWWWCOMP_.freeze
#  end
#
#  def self.decode_www_form(str, enc=Encoding::UTF_8)
#    return [] if str.empty?
#    unless /\A#{WFKV_}=#{WFKV_}(?:[;&]#{WFKV_}=#{WFKV_})*\z/o =~ str
#      raise ArgumentError, "invalid data of application/x-www-form-urlencoded (#{str})"
#    end
#    ary = []
#    $&.scan(/([^=;&]+)=([^;&]*)/) do
#      ary << [decode_www_form_component($1, enc), decode_www_form_component($2, enc)]
#    end
#    ary
#  end
#
#  def self.decode_www_form_component(str, enc=Encoding::UTF_8)
#    raise ArgumentError, "invalid %-encoding (#{str})" unless /\A[^%]*(?:%\h\h[^%]*)*\z/ =~ str
#    str.gsub(/\+|%\h\h/, TBLDECWWWCOMP_).force_encoding(enc)
#  end
#
#  remove_const :WFKV_ if const_defined?(:WFKV_)
#  WFKV_ = '(?:[^%#=;&]*(?:%\h\h[^%#=;&]*)*)' # :nodoc:
#end
