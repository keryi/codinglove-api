module ApplicationHelper
  def decorate(model)
    klass = "#{model.class.name}Decorator".constantize
    decorator = klass.new(model)
    block_given? ? yield(decorator) : decorator
  end
end
