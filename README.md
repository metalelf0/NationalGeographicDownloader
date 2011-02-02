National Geographic Downloader
===

National Geographic photo of the day is so cool, so why cant we setup a script to download them all?
I really enjoy having them as wallpapers, and I used to save them all navigating the site, so I decided to speedup the process!

Here's a small ruby script to do what you need.

Requirements:
----

* ruby, rubygems
* nokogiri
* thor

Usage
----

		$> ./download.rb [-n 10] [-s starting_url] [-r resume]

* -n: number of pictures to download
* -s: starting url if you want to manually resume downloading (should be something like http://photography.nationalgeographic.com/photography/photo-of-the-day/some-picture)
* -r: resume from the last downloaded picture. Every time you download pictures, a file named .last_download is created in the current dir, and this is used to retrieve the last downloaded picture if you want to resume.

