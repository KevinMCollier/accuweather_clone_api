Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ['localhost:3001', 'weather-haiku.xyz']
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :delete, :options]
  end
end
