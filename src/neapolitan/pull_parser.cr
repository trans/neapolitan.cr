module Neapolitan

	class PullParser
    alias EventKind = LibYAML::EventType

    @sections : Array(Section)

    getter sections

		def initialize(content : String | IO)
      # unfortunately we have to convert to a string to do prep
      if content.is_a? String
        text = content
      else
        text = content.gets_to_end
      end

		  @pull_parser = YAML::PullParser.new(prep(text))
		  @anchors = {} of String => YAML::Type

		  @sections = [] of Section #YAML::Any
		end

		def self.new(content)
		  parser = new(content)
		  yield parser ensure parser.close
		end

		def close
		  @pull_parser.close
		end

		def parse
		  loop do
		    case @pull_parser.read_next
		    when EventKind::STREAM_END
		      return @sections
		    when EventKind::DOCUMENT_START
		      @sections << Section.new(@pull_parser.tag, parse_section) #YAML::Any.new(parse_document)
		    else
		      unexpected_event
		    end
		  end
      @sections
		end

		#def parse
		#  value = case @pull_parser.read_next
		#          when EventKind::STREAM_END
		#            nil
		#          when EventKind::DOCUMENT_START
		#            parse_document
		#          else
		#            unexpected_event
		#          end
		#  YAML::Any.new(value)
		#end

		def parse_section
		  @pull_parser.read_next
		  value = parse_node
		  unless @pull_parser.read_next == EventKind::DOCUMENT_END
		    raise "Expected DOCUMENT_END"
		  end
		  value
		end

		def parse_node
		  case @pull_parser.kind
		  when EventKind::SCALAR
		    anchor @pull_parser.value, @pull_parser.scalar_anchor
		  when EventKind::ALIAS
		    @anchors[@pull_parser.alias_anchor]
		  when EventKind::SEQUENCE_START
		    parse_sequence
		  when EventKind::MAPPING_START
		    parse_mapping
		  else
		    unexpected_event
		  end
		end

		def parse_sequence
		  sequence = [] of YAML::Type
		  anchor sequence, @pull_parser.sequence_anchor

		  loop do
		    case @pull_parser.read_next
		    when EventKind::SEQUENCE_END
		      return sequence
		    else
		      sequence << parse_node
		    end
		  end
		end

		def parse_mapping
		  mapping = {} of YAML::Type => YAML::Type
		  anchor mapping, @pull_parser.mapping_anchor

		  loop do
		    case @pull_parser.read_next
		    when EventKind::MAPPING_END
		      return mapping
		    else
		      key = parse_node
		      tag = @pull_parser.tag
		      @pull_parser.read_next
		      value = parse_node
		      if key == "<<" && value.is_a?(Hash) && tag != "tag:yaml.org,2002:str"
		        mapping.merge!(value)
		      else
		        mapping[key] = value
		      end
		    end
		  end
		end

		def anchor(value, anchor)
		  @anchors[anchor] = value if anchor
		  value
		end

		private def unexpected_event
		  raise "Unexpected event: #{@pull_parser.kind}"
		end

		private def raise(msg)
		  ::raise YAML::ParseException.new(msg, @pull_parser.problem_line_number, @pull_parser.problem_column_number)
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
        elsif line.starts_with?("```")
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
