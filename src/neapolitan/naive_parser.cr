module Neapolitan

  #
  def initialize(content : String | IO )
    if content.is_a?(String)

    else

    end
  end

  #
  def parse

  end

  #
  # A simple little multi-document YAML parser, since YAML.parse_all
  # doesn't seem to provide access to tags.
  #
  def parse_markup(markup)
    sections = [] of Section
    text = ""
    type = ""

    File.read_lines(markup).each do |line|
      if line.starts_with?("---")
        sections << Section.new(type, text) unless text.strip == ""
        text = ""
        type = line.strip.sub(/---\s*[!]*/, "")
      else
        text = text + line
      end
    end
    sections << Section.new(type, text) unless text.strip == ""
    sections
  end


end
