#!/usr/bin/env ruby
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'thor'

class NationalGeographicDownloader < Thor

	LAST_DOWNLOADED_PATH = '.last_download'

	desc 'download', 'Downloads pictures'
	method_option :number_of_pictures, :type => :numeric, :aliases => '-n', :default => 10
	method_option :starting_url, :type => :string, :aliases => '-s', :default => "http://photography.nationalgeographic.com/photography/photo-of-the-day"
	method_option :resume_from_last_download, :type => :boolean, :aliases => '-r', :default => false
	def download
		domain_name = "http://photography.nationalgeographic.com"
		if options.resume_from_last_download
			begin
				File.open(LAST_DOWNLOADED_PATH, 'r') do |file|
					@url = file.gets
					puts @url
				end
			rescue Exception => e
				puts "Cannot retrieve last downloaded url, are you sure you already ran this script at least once?"
				exit 1
			end
		else
			@url = options.starting_url
		end
		number_of_downloaded_pictures = 0
		while number_of_downloaded_pictures <= options.number_of_pictures do
			document = Nokogiri::HTML(open(@url))
			download_link = document.css('.download_link a')
			if ( download_link.empty? )
				# skip and go to next page
				puts "Page at url #{@url} has no download link, skipping..."
			else
				# download picture
				print "Download link found in page at url #{@url}, proceeding..."
				image_path = download_link.first.attributes["href"].value
				system("wget #{image_path} 2>/dev/null")
				puts " [DONE]"
				number_of_downloaded_pictures = number_of_downloaded_pictures + 1
			end
			@url = domain_name + document.css('.prev a').first.attributes["href"].value
		end
		puts "Last downloaded picture was at url #{@url}"
		File.open(LAST_DOWNLOADED_PATH, 'w') do |file|
			file.puts @url
		end
	end
end

NationalGeographicDownloader.start


