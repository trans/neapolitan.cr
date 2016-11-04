module Neapolitan

  class NaiveParser
		@content : String | IO
    @sections : Array(Section)

		getter sections

		#
		def initialize(content : String | IO )
		  if content.is_a? String
		    @content = content
		  else
		    @content = content.gets_to_end
		  end

      @sections = Array(Section).new
		end

		#
		# A simple little multi-document YAML parser, since YAML.parse_all
		# doesn't seem to provide access to tags.
		#
		def parse
      @sections = Array(Section).new

		  text = ""
		  tag  = ""

		  @content.each_line do |line|
		    if line.starts_with?("---")
          tag, value = guess(tag, text)
		      @sections << Section.new(tag, value) unless text.strip == ""
		      text = ""
		      tag  = line.strip.sub(/---\s*[!]*/, "")
		    else
		      text = text + line
		    end
		  end

		  @sections << Section.new(tag, text) unless text.strip == ""

		  @sections
		end

    #
    #
    #
    def guess(tag : String?, value : String)
      if tag.nil? || tag == ""
        text = value.strip
        if text.starts_with?("<")
          tag = "html"
        elsif text.starts_with?("#")
          tag = "markdown"
        elsif text =~ /\A\w+\:/
          tag = "metadata"
        else
          tag = "markdown"
        end
      end

      case tag
      when "metadata"
        return tag, yaml(value)
      else
        return tag, value
      end
    end

    #
    #
    #
    private def yaml(value : String)
      YAML.parse(value).raw
    end
  end

end
