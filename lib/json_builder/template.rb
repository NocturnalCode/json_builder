# Rails 2.X Template
if defined?(Rails) && Rails.version =~ /^2/
  require 'action_view/base'
  require 'action_view/template'

  module ActionView
    module TemplateHandlers
      class JSONBuilder < TemplateHandler
        include Compilable

        def compile(template)
          "::JSONBuilder::Compiler.generate {#{template.source}};"
        end
      end
    end
  end

  ActionView::Template.register_template_handler :json_builder, ActionView::TemplateHandlers::JSONBuilder
end

# Rails 3.X Template
if defined?(Rails) && Rails.version =~ /^3/
  module ActionView
    module Template::Handlers
      class JSONBuilder

        class_attribute :default_format
        self.default_format = Mime::JSON

        def self.call(template)
          source = if template.source.empty?
            File.read(template.identifier)
          else # use source
            template.source
          end

          "::JSONBuilder::Compiler.generate {#{source}};"
        end
      end
    end
  end

  ActionView::Template.register_template_handler :json_builder, ActionView::Template::Handlers::JSONBuilder
end
