# # Nkss: Helpers
# A bunch of helpers you can use in your styleguides.

module StyleguideHelper

  # ### kss_block
  # Documents a styleguide block.
  #
  # Some options you can specify:
  #
  #  * `background` - The background color. Can be *clear*, *white*, *black*,
  #  *light*, or *dark*.
  #
  #  * `align` - Text alignment. Can be *left*, *right*, or *center*.
  #
  #  * `width` - (Optional) width for the inner area. Specify this for
  #  documenting long things.
  #
  # Example:
  #
  #     = kss_block '1.1' do
  #       %div.foo
  #         Put markup here!
  #
  # Example with options:
  #
  #     = kss_block '1.1', background: 'dark' do
  #
  def kss_block(section_id, options={}, &block)
    section = @styleguide.section(section_id)

    raise "Section '#{section_id}' not found."  unless section.filename

    example_slim = slim_code_from(*block.source_location, __method__, section_id)
    example_html = capture(&block)

    defaults = { background: 'light', align: 'left', code: 'true' }
    options = defaults.merge(options)

    bg = "bg-#{options[:background]}"
    align = "align-#{options[:align]}"
    classes = [bg, align]

    inner_style = ''
    inner_style = "width: #{options[:width]}px; margin: 0 auto"  if options[:width]

    render \
      partial: 'styleguides/block',
      locals: {
        canvas_class: classes.join(' '),
        code_block: block,
        slim: example_slim,
        html: example_html,
        section: section,
        modifiers: (section.modifiers rescue Array.new),
        options: options,
        inner_style: inner_style,
      }
  end

  # ### kss_specimen
  # Renders a type specimen. This is great for demoing fonts.
  # Use it like so:
  #
  #     = kss_block '2.1' do
  #       .proxima-nova
  #         = kss_specimen
  #
  # This gets you a `<div class='sg-specimen'>` block which has already been
  # styled to showcase different sizes of the given font.

  def kss_specimen
    render partial: 'styleguides/specimen'
  end

  # ### kss_swatch
  # Renders a type specimen. This is great for demoing colors.
  #
  #     = kss_block '2.1' do
  #       = kss_swatch 'red', '#ff3322', description: 'for error text'

  def kss_swatch(name, color, options={})
    render partial: 'styleguides/swatch', locals: {
      name: name,
      identifier: name,
      color: color,
      dark: options[:dark],
      description: options[:description]
    }
  end

  # ### lorem
  # Convenient lorem ipsum helper.
  #
  # Yeah, well, you'll need this for a lot of styleguide sections. Use it like
  # so:
  #
  #     %p= lorem.paragraph
  #     %li= lorem.sentence
  #
  def lorem
    require 'ffaker'

    Faker::Lorem
  end

  # ### kss_markdown
  # Markdownify some text.

  def kss_markdown(text)
    text.gsub!(/^\s*\-*=*\s*\n*/, '') # Strip '----' lines
    lines = text.split("\n")

    # Transform the first line
    if lines.length > 0
      lines[0].gsub!(/^#*\s*/, '## ')         # "Hello" => "## Hello"
      lines[0].gsub!(/\((.*?)\):?$/, '`\1`')  # "Hey (code):" => "Hey `code`"
    end

    text = lines.join("\n")

    # Markdownify
    require 'bluecloth'
    str = BlueCloth.new(text).to_html
    str = str.html_safe  if str.respond_to?(:html_safe)
    str
  end

  # ### parse_html
  # Parse HTML and replace modifier classes
  def parse_html(original_html, modifier_class = false)
    html = original_html.clone

    if modifier_class
      html.gsub!('$modifier_class', "#{modifier_class}")
    else
      html.gsub!(/\s*\$modifier_class/, '')
    end

    html
  end

  private

  def slim_code_from(filename, source_start, method_name, section_id)
    # Example:
    # parsed = parse_ slim(filename)
    # => [:multi,
    #  [:newline],
    #  [:newline],
    #  [:newline],
    #  [:slim,
    #   :output,
    #   true,
    #   "kss_block '1.1' do",
    #   [:multi,
    #    [:newline],
    #    [:html,
    #     :tag,
    #     "div",
    #     [:html, :attrs, [:html, :attr, "class", [:static, "example"]]],
    #     [:multi,
    #      [:newline],
    #      [:slim, :text, :verbatim, [:multi, [:slim, :interpolate, "Example markup"]]],
    #      [:newline]]],
    #    [:html,
    #     :tag,
    #     ".",
    #     [:html, :attrs, [:html, :attr, "class", [:static, "foo"]]],
    #     [:multi, [:newline], [:slim, :output, true, "\"\#{'bar'}\"", [:multi, [:newline]]]]],
    #    [:html,
    #     :tag,
    #     "#",
    #     [:html, :attrs, [:html, :attr, "id", [:static, "baz"]]],
    #     [:multi, [:newline]]],
    #    [:slim, :text, :verbatim, [:multi, [:slim, :interpolate, "xyz"]]],
    #    [:newline]]]]
    #
    parsed = parse_slim(filename)
    source_length = 0
    re = Regexp.new("#{method_name} (\'#{section_id}\'|\"#{section_id}\")")

    parsed.each do |item|
      if item[0].eql?(:slim) && item[3] =~ re
        source_length = count_new_line(item[4])
        break
      end
    end

    # reduce last count of :newline
    source_length -= 1

    File.readlines(filename).slice(source_start, source_length).map do |line|
      line.sub(/\A\s\s/,  '')
    end.join
  end

  def parse_slim(filename)
    unless parsed_slim_cache.has_key?(filename)
     parsed_slim_cache[filename] = Slim::Parser.new.call(File.read(filename))
    end
    parsed_slim_cache[filename]
  end

  def parsed_slim_cache
    @parsed_slim_cache ||= {}
  end

  def count_new_line(ary, num = 0)
    ary.inject(num) do |num, item|
      if item.is_a?(Array)
        num = count_new_line(item, num)
      else
        num += 1 if item.eql?(:newline)
      end
      num
    end
  end

end
