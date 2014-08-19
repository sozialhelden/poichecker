# # tell the I18n library where to find your translations
I18n.enforce_available_locales = true

I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
I18n.default_locale = :de
I18n.available_locales = [:de, :en]
