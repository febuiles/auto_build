module AutoBuild
  class HasOneHook
    attr_reader :model, :association_name

    def initialize(model, name)
      @model = model
      @association_name = name
    end

    def attach
      hook_code = code
      model.class_eval do
        after_initialize do |record|
          record.instance_eval(hook_code)
        end
      end
    end

    def code
      "self.#{association_name} ||= build_#{association_name}"
    end
  end
end
