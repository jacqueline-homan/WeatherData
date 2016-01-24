#!/usr/bin/env ruby

require_relative('functions')

require 'sinatra'
require 'json'

# Accessible via http://localhost:4567

get '/' do 
	text = "<h1>*** Lake Pend Orielle Readings at Deep Moor Station ***</h1>"
	text << "<p>Computes the mean and median of the wind speed,
	air temperature, and barometric pressure recorded at the
	Deep Moor station on Lake Pend Orielle for a given
	range of dates.</p><br/>"
	text << "<p>Submit a request as '/readings?start=01-01-2013&end=02-01-2013'</p>"
	erb text
end

get '/readings' do
	#start_date, end_date = url_params_for_date_range

	#results = get_and_compute_results(start_date, end_date)

	#content_type :json
	#erb results.to_json
	erb :readings_form
end 

post '/readings' do
    READING_TYPES = {
	"Wind_Speed" => "Wind Speed",
	"Air_Temp" => "Air Temp",
	"Barometric_Press" => "mmHg (torr)"
}

    erb :start_date, :end_date => {'Start Date' => start_date, 'End Date' => end_date}
end



not_found do
	erb "Page not found"
end
