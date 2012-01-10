module AutoBuild
  module Builder
    extend ActiveSupport::Concern


    module ClassMethods
      # Public: This method allows you to auto initialize associations
      # in your models. After calling it you don't need to call
      # `build_association` or `association.build` in your controllers
      # or views. Useful for models that accept nested attributes for
      # associations. It **does not** overwrite associations with
      # existing values.
      #
      # An `after_initialize` hook will be created for each one of
      # the associations.
      #
      # Signature
      #
      #   auto_build(<field>, <field>, <field>)
      #   auto_build(<field>, <options>)
      #
      # field   - A Symbol with the name of the association you want
      #           initialize
      # options - A Hash with the options to initialize the
      #           associations. See AutoBuilder::Association#initialize
      #           for the options.
      #
      # Examples
      #
      #     class User
      #       has_one :address
      #       has_many :pictures
      #       has_many :projects
      #     end
      #
      #     auto_build :address, :pictures
      #     # => Builds a record for each association if none is present
      #
      #     auto_build :projects, :count => 3
      #     # => Builds 3 projects each time you initialize a User
      #
      #     auto_build :pictures, :append => true
      #     # => Builds an extra Picture each time you initialize a User
      def auto_build(*attr_names)
        options = attr_names.extract_options!
        names = attr_names

        names.map do |name|
          Association.new(self, name, options).add_hook
        end
      end
    end

    private

    # Private: Calculates the number of new records to create in a
    # `has_many` association.
    #
    # name    - A Symbol with the name of the association.
    # options - The Hash options for the number of records to create.
    #           See AutoBuilder::Association#initialize for more
    #           details.
    #
    # Examples
    #
    #   User.projects.size
    #   # => 1
    #
    #   number_of_records_to_create(:projects)
    #   # => 0
    #
    #   number_of_records_to_create(:projects, :append => true)
    #   # => 1
    #
    #   number_of_records_to_create(:projects, :count => 4)
    #   # => 4 (User.projects.size == 5)
    #
    # Returns the number of records to create.
    def number_of_records_to_create(name, options={})
      current = self.send(name).size
      default_count = current == 0 ? 1 : 0

      if options[:append]
        1
      elsif options[:count]
        options[:count]
      else
        default_count
      end
    end
  end
end
ActiveRecord::Base.send :include, AutoBuild::Builder
