Rails.application.config.generators do |generate|
  generate.test_framework  :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: false,
        request_specs: true
   generate.fixture_replacement :factory_bot, dir: "spec/factories"
end
