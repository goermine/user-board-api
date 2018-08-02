class PasswordValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return true unless value
    unless value.match self.class.password_regexp
      record.errors.add(
        attribute,
        'Password must contains 8 or more characters, a digit, a lower case character, an upper case character'
      )
    end
  end

  def self.password_regexp
    /\A
      (?=.{8,})          # Must contain 8 or more characters
      (?=.*\d)           # Must contain a digit
      (?=.*[a-z])        # Must contain a lower case character
      (?=.*[A-Z])        # Must contain an upper case character
    /x
  end
end
