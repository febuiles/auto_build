module AutoBuild
  class HasManyHook
    attr_reader :model, :association_name, :options

    def initialize(model, name, options)
      @model = model
      @association_name = name
      @options = options
    end

    def attach
      hook_code = code
      name = association_name
      record_options = options

      model.class_eval do
        after_initialize do |record|
          count = number_of_records_to_create(name, record_options)
          record.instance_eval(hook_code * count)
        end
      end
    end

    def code
      "self.#{association_name}.build;"
    end
  end
end
