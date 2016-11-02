# Neapolitan

<img src="logo.png" align="right"/>

[Homepage](http://trans.github.com/neapolitan.cr/) |
[Development](http://github.com/trans/neapolitan.cr) |
[Report Issue](http://github.com/trans/neapolitan.cr/issues)

## DESCRIPTION

There are many markup and templating systems in the
world. Why be limited to just one? Neapolitan gives
you a whole box to pick from.


## FEATURES

* All the variety of a Whitman's Sampler.
* And all the ease of a Hershey's K.I.S.S.
* Our website has pretty colors :smile:


## Usage

Here's a very simple example of Neapolitan markup.

```neapolitan
--- !metadata
name: World
--- !markdown
Hello {{name}}!
```

Library usage:


```crystal
require "neapolitan"

Neapolitan.render(io_or_string)
```

## Compatability

Neapolitan has a little bitty bit of brains to make static blog writers
life easier. If your Neapolitan markup does not provide tags, the library
will take a smart guess at the content. That means traditional Jekyll
style posts/pages with YAML from matter followed by Markdown text will
work!


```neapolitan
---
name: World
---
Hello {{name}}!
```

This will work just like the prior example.


## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  neapolitan:
    github: trans/neapolitan.cr
```


## Development

If you are an author of a Crystal-based markup format, please contact us via
this project's Github issues.


## Contributing

1. Fork it ( https://github.com/trans/neapolitan.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request


## Contributors

- [trans](https://github.com/trans) - creator, maintainer


## Copyrights

Neapolitan Copyright &copy; 2010 Thomas Sawyer

Neapolitan is distributed under the terms of the MIT license.

THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE.


[<img src="http://travis-ci.org/trans/neapolitan.png" />](http://travis-ci.org/trans/neapolitan)



