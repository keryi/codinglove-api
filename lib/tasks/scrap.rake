namespace :scrap do
  require_relative '../scraper/coding_love'

  desc 'scape thecodinglove.com'
  task :codinglove do
    # must limit to once
    cl = Scraper::CodingLove.new

    begin
      cl.scrap
    rescue SystemExit, Interrupt
      puts 'System killed. Lets call it a day!'
      cl.store_state
    end
  end
end
