module ActiveModelErrorExtender
  def as_pretty_json
    errs = []
    attribute_names.each do |attribute|
      errs << { attribute_name: attribute, messages: full_messages_for(attribute) }
    end
    errs
  end
end

ActiveModel::Errors.send(:include, ActiveModelErrorExtender)
