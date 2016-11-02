module Neapolitan

  class Marker
    @content : String | IO

    def initialize(content : String | IO)
      @content = content
    end

    #
    #
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

		  text.join("\n")

		  # TODO: the layout too might need a layout render!
		  #mustache(layout, data)
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
