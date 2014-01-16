[![Build Status](https://travis-ci.org/SciMed/vision_mate.png?branch=master)](https://travis-ci.org/SciMed/vision_mate)

# VisionMate

VisionMate provides a Ruby interface to the Thermo Scientific VisionMate 2D
barcode scanner used to bulk scan multiple test tubes set in a rack. The library
provides a wrapper around the Telnet interface used by the VisionMate scanner.

![Workflow Example](assets/images/vision_mate_workflow.png)

## Installation

Add it to the project's Gemfile with:

```Ruby
gem 'vision_mate'
```

Run the `bundle` command to install it.

## Usage

Configure the connection in an initializer file. e.g.
`config/initializers/vision_mate.rb`

```Ruby
  VisionMate.configure do |config|
    config.host = '192.168.1.1'
    config.port = '8000'
  end
```

Initialize a connection and perform a scan.

```Ruby
  scanner = VisionMate.connect
  scanner.scan # => (results)
```

## Contributing

1. Fork this repository ( http://github.com/SciMed/vision_mate/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Copyright

Copyright (c) 2014 SciMed Solutions Inc. Licensed under the MIT license. See
[LICENSE](LICENSE.txt) for details.
