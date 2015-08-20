require_relative '../../config/environment.rb'
require 'open-uri'
require 'nokogiri'
require 'singleton'

module Scraper
  class CodingLove
    include Singleton

    URL = 'http://thecodinglove.com'
    STATE_FILE = Rails.root.join('tmp', 'state.txt')

    def initialize
      if File.exists? STATE_FILE
        File.open(STATE_FILE, 'r') do |f|
          @last_page_stored, @last_scraped_page = f.gets.strip.split.map(&:to_i)
        end
      else
        @last_page_stored = @last_scraped_page = last_page
        store_state
      end
    end

    def store_state
      File.open(STATE_FILE, 'w') do |f|
        f.puts "#{@last_page_stored}, #{@last_scraped_page}"
      end
    end

    def scrap
      puts 'Hang tight! while we work hard to scrap the best gifs for you.'

      posts = post_urls = post_ids = post_gifs = post_authors = []

      page = @last_scraped_page + (@last_page_stored - last_page)

      begin
        doc = Nokogiri::HTML(open("#{URL}/page/#{page}"))
        post_descs = doc.css('.post h3 a').map { |e| e.children.first.content }
        post_urls = doc.css('.post h3 a').map { |e| e.attributes['href'].value }
        post_ref_ids = post_urls.map { |url| url.scan(/post\/(\d+)\//) }.flatten
        post_images = doc.css('.post .bodytype img').map { |e| e.attributes['src'].value }
        post_authors = doc.css('.post .bodytype .e i').map { |e| e.content.scan(/by\s+(.*)\s+\*/) }.flatten

        create_posts(post_ref_ids, post_descs, post_urls, post_images, post_authors)

        page -= 1
        @last_scraped_page = page
      rescue OpenURI::HTTPError => e
        puts "Opps! it's 404"
        exit -1
      end while page >= 1
    end

    private

    def create_posts(ref_ids, descs, urls, images, authors)
      count = ref_ids.size
      count.times do |i|
        post = {
          ref_id: ref_ids[i],
          url: urls[i],
          image: images[i],
          author: authors[i],
          desc: descs[i]
        }
        post = Post.new(post)
        puts post.errors.full_messages.join(', ') unless post.save
      end
    end

    def last_page
      doc = Nokogiri::HTML(open(URL))
      doc.css('.footer').children.first.content.gsub(/\s+|\u00A0/, '')
          .scan(/^\{\d+\/(\d+)\}$/).flatten.first.to_i
    end
  end
end
