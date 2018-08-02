class TokenAuthentication
  class Invalid < StandardError; end
  class Expired < StandardError; end


  class << self
    EXPERIRATION_TIME = ENV['TOKEN_EXPIRATION_MINUTES'].to_i
    ALGORITHM = 'HS512'.freeze

    def encode(payload, exp = EXPERIRATION_TIME.minutes.from_now)
      payload[:iat] = payload.fetch(:iat, Time.now).to_i
      payload[:exp] = exp.to_i
      JWT.encode(
        payload,
        Rails.application.secrets.secret_key_base,
        ALGORITHM
      )
    end

    def decode(token)
      body = JWT.decode(
        token,
        Rails.application.secrets.secret_key_base,
        true,
        algorithm: ALGORITHM
      ).first
      HashWithIndifferentAccess.new(body)
    rescue JWT::ExpiredSignature, JWT::VerificationError => e
      raise TokenAuthentication::Expired, e.message
    rescue JWT::DecodeError, JWT::VerificationError => e
      raise TokenAuthentication::Invalid, e.message
    end
  end
end
