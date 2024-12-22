require 'securerandom'
class String
  # Определяет если строка может являться OpenID URL идентификатором пользователя
  #  http://myopenid.com/profile/andy => true
  #  http://andy.livejournal.com/ => true
  #  my@email.com => false
  #  string => false
  def openid?
    return true if self =~ %r{^https?://}i
    return true if self =~ /^[a-z0-9-]{1,30}\.(livejournal\.com|myopenid\.com)$/i
    false
  end
  alias_method :is_openid?, :openid?  # keep backward compatibility

  def escape_javascript
    return String.new if self.nil?
    gsub('\\', '\0\0')
      .gsub(/\r\n|\n|\r/, "\\n")
      .gsub(/["']/) { |m| "\\#{m}" }
  end

  def truncate(length = 30, truncate_string = "...")
    return self if blank?
    chars = to_s.mb_chars
    truncate_chars = truncate_string.to_s.mb_chars
    l = length - truncate_chars.length
    (chars.length > length) ? chars.limit(l) + truncate_string : self
  end

  def sql_quote
    ActiveRecord::Base.connection.quote(self)
  end

  class << self
    def random(length = 40)
      SecureRandom.hex((length / 2.0).ceil)
    end
  end
end
