ActiveFedora::Base.class_eval do

  # method_missing is defined, so adding methods

  def auditable?
    begin
      self.is_a? ActiveFedora::Auditable
    rescue
      false
    end
  end

  def has_permissions?
    self.is_a? Hydra::ModelMixins::RightsMetadata
  end

  def governable?
    !is_governed_by_association.nil?
  end

  private

  def governed_by_association
    self.reflections.each do |name, reflection|
      # FIXME add class name condition, i.e.:
      # && reflection.class_name == [Hydra configured policy class or Hydra::AdminPolicy]
      return reflection if reflection.macro == :belongs_to && reflection.options[:property] == :is_governed_by
    end
  end
  
end
