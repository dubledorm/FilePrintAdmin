# Be sure to restart your server when you modify this file.

# Проверяем, что все переменные окружения переданы и верно настроено подключение к ресурсам.
Rails.application.config.after_initialize do
  next unless Rails.env.production?

  # Проверяем соединение с БД
  begin
    Template.first
  rescue => e
    abort "Could not connect to database. #{e.message}.\nPlease check parameters DB_MONGO_HOST, DB_MONGO_DATABASE_NAME" \
          ' and accessible the database'
  end

  # Проверяем установки переменных окружения
  unless ENV['DATA_TO_DOCUMENT_URL']
    abort 'The environment variable DATA_TO_DOCUMENT_URL is not present, please set the variable.'
  end

  # Проверяем доступность сервиса DataToDocument
  begin
    HttpService.new.health_check!
  rescue => e
    warn "Could not connect to service DataToDocument. #{e.message}.\nPlease check parameter DATA_TO_DOCUMENT_URL" \
          ' and accessible the service'
  end
end
