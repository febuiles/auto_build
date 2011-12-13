module AutoBuild
  # Public: Represents an ActiveRecord association. Takes care
  # of adding the hooks to the models.
  class Association
    # Public: Returns the model this association works on.
    attr_reader :model
    # Public: Returns the name of the association.
    attr_reader :association_name
    # Public: Returns the options that were passed in when created.
    attr_reader :options
    # Public: Returns the type (macro) of association (e.g. has_one,
    # :has_many).
    attr_reader:type

    # Public: Creates a new Association.
    #
    # model - The ActiveRecord model (not the instance!).
    # association_name - Name of the association you will want to
    #                    add the callback to.
    # options - The Hash options used to the number of
    #           records (default = {}):
    #           :count  - An Integer that specifies the number of
    #                     records to create.
    #           :append - Boolean, defines if you only want one record
    #                     at the end of the array. False by default.
    #                     Equivalent to :count => 1.
    #
    # `has_one` associations **don't** receive any options.
    #
    # For `has_many` associations, if the user doesn't pass any options,
    # the default will be to add one new record if no other records
    # exist yet.
    #
    # Examples
    #
    #   Association.new(User, :photo)
    #
    #   Association.new(User, :projects, :append => true)
    #
    #   Association.new(User, :projects, :count => 3)
    #
    #   Association.new(user, :photo)
    #   # => Error! You want to pass the class, no the instance
    #
    # Raises AutoBuildError if you pass the :count and :append options
    # at the same time.
    def initialize(model, association_name, options={})
      @model = model
      @association_name = association_name
      @options = options
      @type = model.reflect_on_association(association_name).macro

      validate_options
    end

    # Public: Adds the callback to the objects.
    #
    # It will choose the correct hook based on the value of `type`.
    def add_hook
      if type == :has_one
        has_one_hook
      else
        has_many_hook
      end
    end

    private

    def has_one_hook
      code = "self.#{association_name} ||= build_#{association_name}"

      model.class_eval do
        after_initialize do |record|
          record.instance_eval(code)
        end
      end
    end

    def has_many_hook
      name = association_name
      record_options = options
      code = "self.#{association_name}.build;"

      model.class_eval do
        after_initialize do |record|
          count = number_of_records_to_create(name, record_options)
          record.instance_eval(code * count)
        end
      end
    end

    def validate_options
      if options[:count] && options[:append]
        raise AutoBuildError.new("You can't specify :count and :append at the same time")
      end
    end
  end
end
