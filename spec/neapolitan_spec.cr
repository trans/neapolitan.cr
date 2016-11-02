require "./spec_helper"

describe Neapolitan do

  it "markdown works" do
    markup = <<-HERE
    --- !markdown
    Hello there!
    HERE

    result = Neapolitan.render(markup)

    result.should eq("<p>Hello there!</p>")
  end

  it "html works" do
    markup = <<-HERE
    --- !html
    <i>Hello there!</i>
    HERE

    result = Neapolitan.render(markup)

    result.should eq("<i>Hello there!</i>")
  end

  it "metadata works with mustache" do
    markup = <<-HERE
    --- !metadata
    name: world
    --- !markdown
    Hello {{name}}!
    HERE

    result = Neapolitan.render(markup)

    result.should eq("<p>Hello world!</p>")
  end

  it "metadata works with html" do
    markup = <<-HERE
    --- !metadata
    name: world
    --- !html
    <b>Hello {{name}}!</b>
    HERE

    result = Neapolitan.render(markup)

    result.should eq("<b>Hello world!</b>")
  end

  it "guesses html correctly" do
    markup = <<-HERE
    ---
    <b>Hello mate!</b>
    HERE

    result = Neapolitan.render(markup)

    result.should eq("<b>Hello mate!</b>")
  end

  it "guesses markdown correctly" do
    markup = <<-HERE
    ---
    Hello mate!
    HERE

    result = Neapolitan.render(markup)

    result.should eq("<p>Hello mate!</p>")
  end

  it "guess metadata correctly" do
    markup = <<-HERE
    ---
    name: Bob
    ---
    Hello {{name}}!
    HERE

    result = Neapolitan.render(markup)

    result.should eq("<p>Hello Bob!</p>")
  end

end
