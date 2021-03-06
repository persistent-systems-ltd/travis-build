require 'raven'
require 'sinatra/base'

module Travis
  module Api
    module Build
      class Sentry < Sinatra::Base
        configure do
          if ENV['ENV'] == 'production'
            Raven.configure do |config|
              config.tags = { environment: environment }
            end
            use Raven::Rack
          end
        end
      end
    end
  end
end
