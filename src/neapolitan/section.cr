module Neapolitan

  ##
  # Each YAML document in a YAML strean becomes a Neapolitan section.
  #
  class Section
    @tag   : String
    @value : YAML::Type

    getter tag
    getter value

    def initialize(tag : String?, value : YAML::Type)
      @value = value
      @tag = normalize_type(tag)         
    end

    def normalize_type(tag)
      case tag
      when nil
        guess_type(@value)
      when ""
        guess_type(@value)
      when "md"
        "markdown"
      else
        tag
      end
    end

    #
    # If the tag is empty or nil, this routine makes an educated guess
    # as to wha the tag ought to be.
    #
    def guess_type(value : YAML::Type)
      case value
      when String
        text = value.strip
        if text.starts_with?("<")
          "html"
        elsif text.starts_with?("#")
          "markdown"
        #elsif text =~ /\A\w+\:/
        #  "metadata"
        else
          "markdown"
        end
      when Hash #(YAML::Type, YAML::Type)
        "metadata"
      when Array #(YAML::Type)
        raise "no renderings for array sections"
      else
        raise "no renderings for nil sections"
      end
    end

    #
    #
    #
    def metadata?
      tag == "metadata"
    end

    #
    #
    #
    def as_h
      hash = Hash(String, YAML::Type).new
      value = @value.as(Hash)
      value.each do |key, val|
        hash[key.to_s] = val
      end
      hash
    end

    #
    #
    #
    def as_s
      @value.as(String)
    end

  end

end
