require 'colored'
require 'claide'

module MetaModel
  class Command < CLAide::Command
    require 'metamodel/command/init'
    require 'metamodel/command/generate'
    require 'metamodel/command/build'

    include Config::Mixin

    self.abstract_command = true
    self.command = 'meta'
    self.version = VERSION
    self.description = 'MetaModel, the Model generator.'
    self.plugin_prefixes = %w(claide meta)

    def self.run(argv)
      super(argv)
    end

    def initialize(argv)
      super
      # config.verbose = self.verbose?
      config.verbose = true
    end

    #-------------------------------------------------------------------------#

    private

    # Checks that scaffold folder exists
    #
    # @return [void]
    def verify_scaffold_exists!
      unless config.scaffold_folder
        raise Informative, "No `scaffold' folder found in the project directory."
      end
    end
  end
end
