# codinglove-api

This app will scrap the awesome thecodinglove.com and provide API for the access of the awesome gifs. It also comes with a simple user interface that display those awesome gifs without Ads using keyboard short-cut keys to navigate around the awesome gifs.

Lastly, all the awesome gifs belongs to thecodinglove.com not the author of this app.

## auto-tagging

This app uses Imagga API to perform gifs auto-tagging. Imagga API client can be downloaded from http://files1.restunited.com/libraries/imagga/beta/0/1/0/sw/Imagga-beta-0.1.0-ruby.tar.gz

To install Imagga API client gem from the source
```
tar xzf Imagga-beta-0.1.0-ruby.tar.gz
cd Imagga-ruby
gem build imagga.gemspec
gem install ./imagga-0.1.0.gem
```
