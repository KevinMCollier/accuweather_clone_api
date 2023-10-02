Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ['localhost:3001', 'wonderful-salmiakki-9d2149.netlify.app']
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :delete, :options]
  end
end
