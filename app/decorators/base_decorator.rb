class BaseDecorator < SimpleDelegator
  def initialize(model)
    @model = model
    super(@model)
  end
end
