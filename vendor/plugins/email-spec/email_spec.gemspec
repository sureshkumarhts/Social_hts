# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{email_spec}
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ben Mabey", "Aaron Gibralter", "Mischa Fierer"]
  s.date = %q{2009-07-18}
  s.description = %q{Easily test email in rspec and cucumber}
  s.email = %q{ben@benmabey.com}
  s.extra_rdoc_files = [
    "MIT-LICENSE.txt",
     "README.rdoc"
  ]
  s.files = [
    "History.txt",
     "MIT-LICENSE.txt",
     "README.rdoc",
     "Rakefile",
     "examples/rails_root/Rakefile",
     "examples/rails_root/app/controllers/application.rb",
     "examples/rails_root/app/controllers/welcome_controller.rb",
     "examples/rails_root/app/helpers/application_helper.rb",
     "examples/rails_root/app/helpers/welcome_helper.rb",
     "examples/rails_root/app/models/user.rb",
     "examples/rails_root/app/models/user_mailer.rb",
     "examples/rails_root/app/views/user_mailer/signup.erb",
     "examples/rails_root/app/views/welcome/confirm.html.erb",
     "examples/rails_root/app/views/welcome/index.html.erb",
     "examples/rails_root/app/views/welcome/signup.html.erb",
     "examples/rails_root/config/boot.rb",
     "examples/rails_root/config/database.yml",
     "examples/rails_root/config/environment.rb",
     "examples/rails_root/config/environments/development.rb",
     "examples/rails_root/config/environments/production.rb",
     "examples/rails_root/config/environments/test.rb",
     "examples/rails_root/config/initializers/inflections.rb",
     "examples/rails_root/config/initializers/mime_types.rb",
     "examples/rails_root/config/initializers/new_rails_defaults.rb",
     "examples/rails_root/config/routes.rb",
     "examples/rails_root/cucumber.yml",
     "examples/rails_root/db/migrate/20090125013728_create_users.rb",
     "examples/rails_root/db/schema.rb",
     "examples/rails_root/doc/README_FOR_APP",
     "examples/rails_root/features/errors.feature",
     "examples/rails_root/features/example.feature",
     "examples/rails_root/features/step_definitions/email_steps.rb",
     "examples/rails_root/features/step_definitions/user_steps.rb",
     "examples/rails_root/features/step_definitions/webrat_steps.rb",
     "examples/rails_root/features/support/env.rb",
     "examples/rails_root/public/404.html",
     "examples/rails_root/public/422.html",
     "examples/rails_root/public/500.html",
     "examples/rails_root/public/dispatch.rb",
     "examples/rails_root/public/favicon.ico",
     "examples/rails_root/public/images/rails.png",
     "examples/rails_root/public/javascripts/application.js",
     "examples/rails_root/public/javascripts/controls.js",
     "examples/rails_root/public/javascripts/dragdrop.js",
     "examples/rails_root/public/javascripts/effects.js",
     "examples/rails_root/public/javascripts/prototype.js",
     "examples/rails_root/public/robots.txt",
     "examples/rails_root/script/about",
     "examples/rails_root/script/autospec",
     "examples/rails_root/script/console",
     "examples/rails_root/script/cucumber",
     "examples/rails_root/script/dbconsole",
     "examples/rails_root/script/destroy",
     "examples/rails_root/script/generate",
     "examples/rails_root/script/performance/benchmarker",
     "examples/rails_root/script/performance/profiler",
     "examples/rails_root/script/performance/request",
     "examples/rails_root/script/plugin",
     "examples/rails_root/script/process/inspector",
     "examples/rails_root/script/process/reaper",
     "examples/rails_root/script/process/spawner",
     "examples/rails_root/script/runner",
     "examples/rails_root/script/server",
     "examples/rails_root/script/spec",
     "examples/rails_root/script/spec_server",
     "examples/rails_root/spec/controllers/welcome_controller_spec.rb",
     "examples/rails_root/spec/model_factory.rb",
     "examples/rails_root/spec/models/user_mailer_spec.rb",
     "examples/rails_root/spec/models/user_spec.rb",
     "examples/rails_root/spec/rcov.opts",
     "examples/rails_root/spec/spec.opts",
     "examples/rails_root/spec/spec_helper.rb",
     "examples/rails_root/stories/all.rb",
     "examples/rails_root/stories/helper.rb",
     "examples/rails_root/vendor/plugins/email_spec/rails_generators/email_spec/email_spec_generator.rb",
     "examples/rails_root/vendor/plugins/email_spec/rails_generators/email_spec/templates/email_steps.rb",
     "install.rb",
     "lib/email-spec.rb",
     "lib/email_spec.rb",
     "lib/email_spec/address_converter.rb",
     "lib/email_spec/cucumber.rb",
     "lib/email_spec/deliveries.rb",
     "lib/email_spec/email_viewer.rb",
     "lib/email_spec/helpers.rb",
     "lib/email_spec/matchers.rb",
     "rails_generators/email_spec/email_spec_generator.rb",
     "rails_generators/email_spec/templates/email_steps.rb",
     "spec/email_spec/matchers_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/bmabey/email-spec/}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{email-spec}
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Easily test email in rspec and cucumber}
  s.test_files = [
    "spec/email_spec/matchers_spec.rb",
     "spec/spec_helper.rb",
     "examples/rails_root/app/controllers/application.rb",
     "examples/rails_root/app/controllers/welcome_controller.rb",
     "examples/rails_root/app/helpers/application_helper.rb",
     "examples/rails_root/app/helpers/welcome_helper.rb",
     "examples/rails_root/app/models/user.rb",
     "examples/rails_root/app/models/user_mailer.rb",
     "examples/rails_root/config/boot.rb",
     "examples/rails_root/config/environment.rb",
     "examples/rails_root/config/environments/development.rb",
     "examples/rails_root/config/environments/production.rb",
     "examples/rails_root/config/environments/test.rb",
     "examples/rails_root/config/initializers/inflections.rb",
     "examples/rails_root/config/initializers/mime_types.rb",
     "examples/rails_root/config/initializers/new_rails_defaults.rb",
     "examples/rails_root/config/routes.rb",
     "examples/rails_root/db/migrate/20090125013728_create_users.rb",
     "examples/rails_root/db/schema.rb",
     "examples/rails_root/features/step_definitions/email_steps.rb",
     "examples/rails_root/features/step_definitions/user_steps.rb",
     "examples/rails_root/features/step_definitions/webrat_steps.rb",
     "examples/rails_root/features/support/env.rb",
     "examples/rails_root/public/dispatch.rb",
     "examples/rails_root/spec/controllers/welcome_controller_spec.rb",
     "examples/rails_root/spec/model_factory.rb",
     "examples/rails_root/spec/models/user_mailer_spec.rb",
     "examples/rails_root/spec/models/user_spec.rb",
     "examples/rails_root/spec/spec_helper.rb",
     "examples/rails_root/stories/all.rb",
     "examples/rails_root/stories/helper.rb",
     "examples/rails_root/vendor/plugins/email_spec/rails_generators/email_spec/email_spec_generator.rb",
     "examples/rails_root/vendor/plugins/email_spec/rails_generators/email_spec/templates/email_steps.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
