module GenggengAttachments
  class Engine < ::Rails::Engine
    isolate_namespace GenggengAttachments

    initializer "genggeng_attachments.i18n.load_path" do |app|
      app.config.i18n.load_path += Dir["#{Rails.root}/config/locales/**/*.yml"]
    end
  end
end