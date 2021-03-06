# Sample Sinatra Application using the contentful.com Delivery API

Contentful is a CMS as a Service and allows you to create your own platforms without building the same backend over and over again.

This demo was created during our hackathon at the contentful.com office in the heart of Berlin.


## The App

The app itself uses [Sinatra](http://www.sinatrarb.com/) and the [contentful.rb](https://github.com/contentful/contentful.rb) library.

The permalinks are created dynamically and stored in Redis. Also the content itself is cached as serialized JSON to improve the page load time.

## Using it

Clone the repository and run
  bundle install

After successfully installing the dependencies execute
  rackup

You need to create a space and a content model to be able to use it.


### BlogPost Content-Type
![BlogPost](images/BlogPost.png "BlogPost")

### BlogCategory Content-Type
![BlogCategory](images/BlogCategory.png "BlogCategory")


**This code is a showcase on how to use the API and the Ruby library.**


## Disclaimer

This project is at proof of concept stage and is built on a best
effort kind of approach without strict guarantees of correctness.

## License

Copyright (c) 2014 Contentful GmbH - Andreas Tiefenthaler. See LICENSE.txt for further details.
