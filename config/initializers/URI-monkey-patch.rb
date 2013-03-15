module URI
  major, minor, patch = RUBY_VERSION.split('.').map { |v| v.to_i }

  if major == 1 && minor == 9
    def self.decode_www_form_component(str, enc=Encoding::UTF_8)
      if TBLDECWWWCOMP_.empty?
        tbl = {}
        256.times do |i|
          h, l = i>>4, i&15
          tbl['%%%X%X' % [h, l]] = i.chr
          tbl['%%%x%X' % [h, l]] = i.chr
          tbl['%%%X%x' % [h, l]] = i.chr
          tbl['%%%x%x' % [h, l]] = i.chr
        end
        tbl['+'] = ' '
        begin
          TBLDECWWWCOMP_.replace(tbl)
          TBLDECWWWCOMP_.freeze
        rescue
        end
      end
      str = str.gsub(/%(?![0-9a-fA-F]{2})/, "%25")
      raise ArgumentError, "invalid %-encoding (#{str})" unless /\A[^%]*(?:%\h\h[^%]*)*\z/ =~ str
      str.gsub(/\+|%\h\h/, TBLDECWWWCOMP_).force_encoding(enc)
    end

    remove_const :WFKV_
    WFKV_ = '(?:[^%#=;&]*(?:%\h\h[^%#=;&]*)*)' # :nodoc:
  end
end
