require 'greentable/view_helpers'
require 'greentable/export'

module Greentable
  class Railtie < Rails::Railtie
    initializer "greentable.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end

    initializer "greentable.rackexport" do |app|
      app.middleware.use Greentable::Export
    end
  end
end
