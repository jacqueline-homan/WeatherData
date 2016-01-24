#!/usr/bin/env ruby
require_relative('functions')

puts "\n***  Lake Pend Orielle Readings at Deep Moor Station     ***"
puts "* Computes Mean and Median Windspeeds, Air Temperatures, and *"
puts "* Barometric Pressures at the Deep Moor Naval Station on     *"
puts "* Lake Pend Orielle for a given date range.                  *"
puts "**************************************************************"

start_date, end_date = query_user_for_date_range

#puts start_date.strftime('%B %d, %Y')
#puts end_date.strftime('%B %d, %Y')
#READING_TYPES.each do |type, label|
#	readings = get_readings_from_remote_for_dates(type, start_date, end_date)
#	puts "#{label}: " + readings.join(", ")
#end

### We change this to give user a prettier output to look at###
#results = get_and_compute_results(start_date, end_date)
#puts results.inspect
results = get_and_compute_results(start_date, end_date)
output_results_table(results)