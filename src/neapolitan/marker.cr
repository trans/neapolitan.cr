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
        text = content.read
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
    # Because YAML doesn't support strings that aren't indeneted.
    #
    private def prep(text : String)
      build = Array(String).new
      text.each_line do |line|
        if line.starts_with?("---")
          build << line
        else
          build << "  " + line
        end
      end
puts build.join
      build.join
    end
  end

end
