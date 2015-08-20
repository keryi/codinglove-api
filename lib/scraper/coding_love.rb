require_relative "../../config/environment.rb"

module Scraper
  require 'open-uri'
  require 'nokogiri'

  class CodingLove
    def initialize
      if File.exists? 'tmp.txt'
        File.open('tmp.txt', 'r') { |f| @last_page_stored, @last_scraped_page = f.gets.strip.split.map(&:to_i) }
      else
        @last_page_stored = @last_scraped_page = last_page
        store_state
      end
    end

    def last_page
      doc = Nokogiri::HTML(open('http://thecodinglove.com'))
      doc.css('.footer').children.first.content.gsub(/\s+|\u00A0/, '').scan(/^\{\d+\/(\d+)\}$/).flatten.first.to_i
    end

    def store_state
      puts 'storing states...'
      puts "last page stored: #{@last_page_stored}\nlast scraped page: #{@last_scraped_page}"
      File.open('tmp.txt', 'w') { |f| f.puts "#{@last_page_stored}, #{@last_scraped_page}" }
    end

    def scrap
      puts 'Hang tight! while we work hard to scrap the best gifs for you.'

      posts = post_urls = post_ids = post_gifs = post_authors = []

      page = @last_scraped_page + (@last_page_stored - last_page)

      # if last_page change, increase in this case, we continue to scrap at
      # page = last_page - last_page_stored
      # last_page_stored is the last_page for particular scrap cycle, stored somewhere else
      # keep polling for last_page changed, once a week maybe
      begin
        doc = Nokogiri::HTML(open("http://thecodinglove.com/page/#{page}"))
        post_descs = doc.css('.post h3 a').map { |e| e.children.first.content }
        post_urls = doc.css('.post h3 a').map { |e| e.attributes['href'].value }
        post_ids = post_urls.map { |url| url.scan(/post\/(\d+)\//) }.flatten
        post_gifs = doc.css('.post .bodytype img').map { |e| e.attributes['src'].value }
        post_authors = doc.css('.post .bodytype .e i').map { |e| e.content.scan(/by\s+(.*)\s+\*/) }.flatten

        post_count = post_urls.size
        post_count.times do |i|
          post = {
            ref_id: post_ids[i],
            url: post_urls[i],
            image: post_gifs[i],
            author: post_authors[i],
            desc: post_descs[i]
          }
          begin
            Post.create!(post)
          rescue => e
            puts e
          end
        end

        puts "scraped post: #{Post.count}"

        page -= 1
        @last_scraped_page = page
      end while page >= 1
    end
  end
end
