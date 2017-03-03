class StyleguidesController < ActionController::Base

  helper_method :styleguide_options
  helper_method :styleguide_title
  helper_method :styleguide_sections
  helper_method :styleguide_root
  helper_method :styleguide_namespace

  delegate :with_namespace, to: :view_context

  before_filter :set_styleguide, :only => [ :show, :all ]

  def show
    @section = params[:section].to_i

    render template: with_namespace("styleguides/#{@section}"), layout: with_namespace('styleguide_page')
  end

  def all
    @sections = styleguide_sections
    @single_page = true
    render template: with_namespace("styleguides/all"), layout: with_namespace('styleguide_page')
  end

private

  def set_styleguide
    require 'kss'
    @styleguide = Kss::Parser.new(styleguide_root)
  end

  def styleguide_options
    @styleguide_options ||= YAML::load_file("#{Rails.root}/config/styleguides.yml")
  end

  def styleguide_title
    styleguide_options['title']
  end

  def styleguide_sections
    styleguide_options['sections']
  end

  def styleguide_root
    path = styleguide_options['root'] || '/app/assets/stylesheets'
    File.join Rails.root, path
  end

  def styleguide_namespace
    styleguide_options['namespace']
  end
end
