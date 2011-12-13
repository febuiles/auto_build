module AutoBuild
  module Builder
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      # Public: This method allows you to auto initialize associations
      # in your models. After calling it you don't need to call
      # `build_association` or `association.build` in your controllers
      # or views. Useful for models that accept nested attributes for
      # associations. It **does not** ovewrite associations with existing
      # values.
      #
      # An `after_initialize` hook will be created for each one of
      # the associations.
      #
      # associations - A symbol or array with the associations you want to build
      #
      # Examples
      #
      #     class User
      #       has_one :address
      #       has_one :phone
      #       has_many :pictures
      #       auto_build :address, :phone, :pictures
      #     end
      #
      def auto_build(*attr_names)
        options = attr_names.extract_options!
        associations = attr_names
        associations.each { |a| add_callback(a, options) }
      end

      private

      def add_callback(name, options)
        code = code_for_association(name)
#        times = options[:times] || 1
        num = 1

        after_initialize do |record|
          num.times { record.instance_eval(code) }
        end
      end

      def code_for_association(name)
        type = association_type(name)
        if type == :has_one
          has_one_code(name)
        else
          has_many_code(name)
        end
      end

      def association_type(name)
        self.reflect_on_association(name).macro
      end

      def has_one_code(name)
        "self.#{name} ||= build_#{name}"
      end

      def has_many_code(name)
        "self.#{name}.build unless #{name}.any?"
      end
    end
  end
end
ActiveRecord::Base.send :include, AutoBuild::Builder
