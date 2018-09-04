require 'rails/generators'
module GenggengAttachments
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "install basic files"
      source_root File.expand_path("../templates", __FILE__)


      # def add_initializer
      #   path = "#{Rails.root}/config/initializers/genggeng_attachments.rb"
      #   if File.exists?(path)
      #     puts "Skipping config/initializers/genggeng_attachments.rb creation, as file already exists!"
      #   else
      #     puts "Adding genggeng_attachments initializer (config/initializers/genggeng_attachments.rb)..."
      #     template "config/initializers/genggeng_attachments.rb", path
      #   end
      # end

      def add_routes
        route 'mount GenggengAttachments::Engine, at: "/genggeng_attachments"'
      end

      def add_migrations
        migration_num = Time.now.strftime("%Y%m%d%H%M%S")
        template "attachments_migration.rb", File.join('db/migrate', '', "#{migration_num}_create_genggeng_attachments.rb")
      end
    end
  end
end