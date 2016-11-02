require "yaml"
require "markdown"
require "crustache"

require "./neapolitan/*"

module Neapolitan

  def self.render(markup : String | IO)
    marker = Marker.new(markup)
    marker.render
  end

end

