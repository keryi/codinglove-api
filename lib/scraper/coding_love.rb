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
      if File.exist? STATE_FILE
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
      Rails.logger.info 'Hang tight! while we work hard to scrap the best gifs for you.'
      page = @last_scraped_page + (@last_page_stored - last_page)

      loop do
        begin
          posts = scrap_post(page)

          create_posts(posts)

          page -= 1
          @last_scraped_page = page
        rescue OpenURI::HTTPError => e
          Rails.logger.fatal "Opps! it's 404 when scraping. Got: #{e}"
          break
        end
        break if page <= 1
      end
    end

    private

    def scrap_post(page)
      doc = Nokogiri::HTML(open("#{URL}/page/#{page}"))

      post_descs = doc.css('.post h3 a').map { |e| e.children.first.content }
      post_urls = doc.css('.post h3 a').map { |e| e.attributes['href'].value }
      post_ref_ids = post_urls.map { |url| url.scan(%{post\/(\d+)\/}) }.flatten
      post_images = doc.css('.post .bodytype img').map { |e| e.attributes['src'].value }
      post_authors = doc.css('.post .bodytype .e i').map { |e| e.content.scan(/by\s+(.*)\s+\*/) }.flatten

      post_ref_ids.each_with_index.map do |ref_id, i|
        {
          ref_id: ref_id,
          url: post_urls[i],
          image: post_images[i],
          author: post_authors[i],
          desc: post_descs[i]
        }
      end
    end

    def create_posts(posts)
      posts.each do |post|
        post = Post.new(post)
        Rails.logger.fatal post.errors.full_messages.join(', ') unless post.save
      end
    end

    def last_page
      doc = Nokogiri::HTML(open(URL))
      doc.css('.footer').children.first.content.gsub(/\s+|\u00A0/, '')
        .scan(%{^\{\d+\/(\d+)\}$}).flatten.first.to_i
    end
  end
end
