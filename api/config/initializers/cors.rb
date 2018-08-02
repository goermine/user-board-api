Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins(
      /localhost(:\d+)\z/,
      /127\.0\.0\.1(:\d+)\z/,
      /\Ahttp:\/\/192\.168\.\d{0,255}\.\d{0,255}(:\d+)?\z/
    )
    resource '*',
      headers: :any,
      methods: %i(get post put patch delete options head)
  end
end
