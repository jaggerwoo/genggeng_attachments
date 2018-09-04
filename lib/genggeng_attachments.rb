require "genggeng_attachments/version"
require "genggeng_attachments/engine"
require "genggeng_attachments/configration"

require "generators/genggeng_attachments/install_generator"

require 'simple_form'
require 'carrierwave'
require 'mini_magick'
require 'jquery-fileupload-rails'

module GenggengAttachments
  class << self
    def config
      return @config if defined?(@config)
      @config = Configuration.new
      @config.limit_number = 3
      @config
    end

    def configure(&block)
      config.instance_exec(&block)
    end
  end
end



