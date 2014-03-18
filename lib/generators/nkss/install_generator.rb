require 'rails/generators/base'

module Nkss
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../../templates', __FILE__)
    desc 'Nkss Rails Install'

    def install_steps
      copy_file '1.html.slim', 'app/views/styleguides/1.html.slim'
      copy_file 'styleguides.yml', 'config/styleguides.yml'
      copy_file 'styleguide-extras.scss', 'app/assets/stylesheets/styleguide-extras.scss'
      copy_file 'example-for-styleguides.css', 'app/assets/stylesheets/example-for-styleguides.css'
      copy_file 'styleguide.html.slim', 'app/views/layouts/styleguide.html.slim'

      route "mount Nkss::Engine => '/styleguides' if Rails.env.development?"
    end
  end
end
