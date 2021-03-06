require 'rubygems'
require 'bundler'

Bundler.require
$: << File.expand_path('../', __FILE__)

require 'dotenv'
Dotenv.load

require 'nyny'
require 'models'
require 'search'

module ECI
  class App < NYNY::App
    use Rack::Static, :urls => ['/css', '/js', '/images'], :root => 'public'

    # home page with search box
    get '/' do
      render('index.erb', :title => 'Coursory - Search Courses Quickly',
             :terms => ECI::Search::TERMS, :units => ECI::Search::UNITS,
             :gers => ECI::Search::GERS, :subjects => ECI::Search::SUBJECTS)
    end

    # returns courses that match the given query in JSON
    get '/search' do
      filters = ECI::Search.extract_filters(params)

      page = params[:page] ? params[:page].to_i : 0
      courses = ECI::Search.match(params[:query], filters, page)

      headers['Content-Type'] = 'application/json'
      courses.to_json
    end
  end
end

include ECI::Models
