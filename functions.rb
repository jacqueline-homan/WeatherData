require 'readline'
require 'date'
require 'open-uri'
# Earliest date for which there is consistent data
DATA_START_DATE = '2006-09-20'

# We want to be kind to the remote server. There will be 3
# queries: Winds, Air Temperature, Barometric Pressure. So 
# we will limit the range of dates for these requests that
# will be "ringing the server's doorbell" to only 7 days
MAX_DAYS = 7

# The supported reading types as a hash. 
# Each key is the name used by the remote server to locate the data.
# Each value is a plain text label for that data
READING_TYPES = {
	"Wind_Speed" => "Wind Speed",
	"Air_Temp" => "Air Temp",
	"Barometric_Press" => "mmHg (torr)"
}

# Prompt user for valid date inputs
def query_user_for_date_range
	start_date = nil
	end_date = nil

	until start_date && end_date
		puts "\n First, we need a start date."
		start_date = query_user_for_date

		puts "Next, we need an end date."
		end_date = query_user_for_date

		if !date_range_valid?(start_date, end_date)
			puts "Let's try again"
			start_date = end_date = nil
		end
	end

	return start_date, end_date
end

# Prompt user for a single valid date
# Used for both start_date and end_date
# NOTE: Ruby's Date library handling of dates.
def query_user_for_date
	date = nil
	until date.is_a? Date
		prompt = "Please enter a date (day, month, year) DD-MM-YYYY: "
		resp = Readline.readline(prompt, true)

		# User has option to exit program at any time
		exit if ['q', 'x', 'exit', 'quit'].include?(resp)

		begin 
			date = Date.parse(resp)
		rescue ArgumentError
			puts "\n Invalid date format"
		end
		date = nil unless date_valid?(date)
	end
	return date
end

#Test if a single date is valid
def date_valid?(date)
	valid_dates = Date.parse(DATA_START_DATE)..Date.today
	if valid_dates.cover?(date)
		return true
	else
		puts "\n Date must be after #{DATA_START_DATE} and before today."
		return false
	end
end

# Test if a range of dates is valid
def date_range_valid?(start_date, end_date)
	if start_date > end_date
		puts "Start date must be before end date"
		return false
	elsif start_date + MAX_DAYS < end_date
		puts "\n No more than #{MAX_DAYS}. Be nice to the remote server."
		return false
	end
	return true
end

### Retrieve remote data ###
# Gets readings for particular reading types for a
# range of dates from the remote server as an array of
# floating point values.
def get_readings_from_remote_for_dates(type, start_date, end_date)
	readings = []
	start_date.upto(end_date) do |date|
		readings += get_readings_from_remote(type, date)
	end
	return readings
end

# Gets readings for particular reading types for a particular
# date from the remote server as an array of floating point values.
def get_readings_from_remote(type, date)
	raise "Invalid Reading Type" unless READING_TYPES.keys.include?(type)
	
	# Read remote file, split into an array
	base_url = "http://lpo.dt.navy.mil/data/DM/"
	url = "#{base_url}/#{date.year}/#{date.strftime("%Y_%m_%d")}/#{type}"
		puts "Retrieving: #{url}"
		data = open(url).readlines

	# Extract the readings from each line
	readings = data.map do |line|
		line_items = line.chomp.split(" ")
		reading = line_items[2].to_f
	end
	return readings
end

### Data calculations ###
def mean(array)
	total = array.inject(0) {|sum, x| sum += x}
	return total.to_f / array.length
end

def median(array)
	array.sort!
	length = array.length
	# Odd length, return middle number
	if length % 2 == 1
		return array[length/2]
	else
		# Even length, average the two middle numbers
		item1 = array[length/2 - 1]
		item2 = array[length/2]
		return mean([item1, item2])
	end
end

# Given a start and end date, it will iterate over all
# the supported READING_TYPES, get the values from the
# remote server, and compute the results (the average
# and median values). Results are returned in a hash.
def get_and_compute_results(start_date, end_date)
	results = {}
	READING_TYPES.each do |type, label|
		readings = get_readings_from_remote_for_dates(type, start_date, end_date)
		results[label] = {
			:mean => mean(readings),
			:median => median(readings)
		}
	end
	return results
end

# Make a nice output table for the user
def output_results_table(results={})
	puts "-----------------------------------------"
	puts "| Type 	     | Mean 	   | Median   	|"
	puts "-----------------------------------------"
	results.each do |label, hash|
		print "| " + label.ljust(10) + " | "
		print sprintf("%.6f", hash[:mean]).rjust(10) + " | "
		print sprintf("%.6f", hash[:median]).rjust(10) + " | \n"
	end
	puts
end

### API methods ###

# Use the URL parameters for finding valid start and end dates
def readings
	start_date, end_date = query_user_for_date_range
end

def url_params_for_date_range
	begin
		start_date = Date.parse(params[:start])
		end_date = Date.parse(params[:end])
	rescue ArgumentError
		halt "Invalid date format"
	end

	# Call our validations
	if !date_valid?(end_date)
		halt "Start date must be after #{DATA_START_DATE} and before today."
	elsif !date_valid?(end_date)
		halt "End date must be after #{DATA_START_DATE} and before today."
	elsif !date_range_valid?(start_date, end_date)
		halt "Invalid date range."
	end

	return start_date, end_date
end
