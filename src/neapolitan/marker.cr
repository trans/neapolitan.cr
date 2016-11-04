module Neapolitan

  ##
  # Marker is the main class used to render neapoltian markup.
  # It interfaces with a parser which produces an array of sections.
  # It then takes the sections and generates the final output.
  #
  class Marker
    @content : String | IO
    @data : Hash(String, YAML::Type)

    #
    # Create new Marker instance given neapolitan stream in the 
    # form of String or IO.
    #
    def initialize(content : String | IO)
      @content = content

      # this will just be replaced, but we have to initialize it
      @data = Hash(String, YAML::Type).new
    end

    #
    # Render neapolitan stream.
    #
    def render
      sections = Array(Section).new
      #parser = PullParser.new(@content)
      parser = NaiveParser.new(@content)
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

  end

end
