Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'localhost:3001' # adjust this if your React app is on a different port
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :delete, :options]
  end
end
