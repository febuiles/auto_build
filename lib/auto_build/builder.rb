module AutoBuild
  module Builder
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      # Public: This method allows you to auto initialize `has_one` associations
      # in your models. After calling it you don't need to call
      # `build_association` in your controllers or views. Useful for models
      # that accept nested attributes for associations. It **does not** ovewrite
      # associations with existing values.
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
      #       auto_build :address, :phone
      #     end
      #
      def auto_build(*associations)
        associations = [associations] unless associations.kind_of?(Array)

        associations.each do |assoc|
          after_initialize do |record|
            record.instance_eval("self.#{assoc} ||= build_#{assoc}")
          end
        end
      end
    end
  end
end
ActiveRecord::Base.send :include, AutoBuild::Builder
