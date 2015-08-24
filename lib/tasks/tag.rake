namespace :tagger do
  require_relative '../tagger/imagga'

  desc 'auto-tagging images'
  task :run do
    imagga = Tagger::Imagga.new(ENV['IMAGGA_API_KEY'], ENV['IMAGGA_API_SECRET'])

    Post.all.each do |post|
      next if post.imagga_tags.any?
      puts "retrieving tags for post #{post.id}"
      result = imagga.retrieve_tags(post.image)
      result.tags.each do |tag|
        post.imagga_tags.create tag
      end if result.success?
    end
  end
end
