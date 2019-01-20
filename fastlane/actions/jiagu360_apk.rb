module Fastlane
  module Actions

    # module SharedValues
    #   UPLOAD_APK_TO_FIR_CUSTOM_VALUE = :UPLOAD_APK_TO_FIR_CUSTOM_VALUE
    # end

    class Jiagu360ApkAction < Action
      def self.run(params)
        Actions.sh "pwd"
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "A short description with <= 80 characters of what this action does"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "You can use this action to do cool things..."
      end

      def self.available_options
        # Define all options your action supports.

        # Below a few examples
        []
      end

      def self.return_value
        # If you method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["issenn"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
