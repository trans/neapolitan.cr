module Neapolitan

  class Marker
    @content : String | IO
    @data : Hash(String, YAML::Type)

    #
    # Create new Marker instance given neapolitan stream in the 
    # form of String or IO.
    #
    def initialize(content : String | IO)
      if content.is_a? String
        text = content
      else
        text = content.gets_to_end
      end

      @content = prep(text)

      # this will just be replaced, but we have to initialize it
      @data = Hash(String, YAML::Type).new
    end

    #
    # Render neapolitan stream.
    #
    def render
      sections = Array(Section).new
      parser = PullParser.new(@content)
      parser.parse
      render_sections(parser.sections)
    end

		#
		# TODO We need a way to specify that the section does not need mustache.
		#
		# TODO Can sections support layouts too?
    #
    # TODO Store front matter data for possible access.
		#
		private def render_sections(sections : Array(Section))
		  data = Hash(String, YAML::Type).new
		  text = Array(String).new

		  sections.each do |section|
		    case section.tag
		    when "metadata"
		      data.merge!(section.as_h)  #(yaml(section.value))
		    when "markdown"
		      text << markdown(mustache(section.as_s, data))
		    when "html"
		      text << mustache(section.as_s, data)
		    end
		  end

      # save the data
      @data = data

      # join the section texts and return it
		  text.join("\n")

		  # TODO: the layout too might need a layout render!
		  #mustache(layout, data)
		end

    #
    # Provide access to the data.
    #
    def data
      @data
    end

    #
    # Convert Markdown to HTML.
    #
    private def markdown(text)
      Markdown.to_html(text)
    end

    #
    # Apply mustache templating.
    #
    private def mustache(text, data)
      template = Crustache.parse(text)
     	Crustache.render(template, data)
    end

    #
    # This preprocessor does two things.
    #
    # 1. Because YAML doesn't support root strings that are not indented,
    #    this routiune adds two spaces of indention to every line other
    #    than document separater lines (`---` and `...`).
    #
    # 2. By default block strings are flow style which means one new line
    #    character is lost when blank lines are encountered. We correct this
    #    by making the default literal instead by adding `|` to `---` lines.
    #
    # TODO: To be fully compliant with spec we may need to consider %TAG lines
    #       when indenting.
    #
    private def prep(text : String)
      build = Array(String).new
      text.each_line do |line|
        if line.starts_with?("---")
          build << line
        elsif line.starts_with?("...")
          build << line
        elsif line.strip.empty?
          build << line
          build << line
        else
          build << "  " + line
        end
      end
      build.join
    end

  end

end
