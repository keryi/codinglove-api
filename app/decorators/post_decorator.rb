class PostDecorator < BaseDecorator
  def tags
    @model.imagga_tags.map { |tag| "##{tag.name}" }.join ' '
  end
end
