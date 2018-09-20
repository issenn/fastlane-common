module Fastlane
  module Actions
    class GradleVersionAction < Action
      def self.run(params)
        Action.sh "./gradlew -v"
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Check gradle version."
      end

      def self.details
        "Check gradle version."
      end

      def self.available_options
        []
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
