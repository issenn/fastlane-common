module Fastlane
  module Actions

    module SharedValues
      UPLOAD_APK_TO_FIR_CUSTOM_VALUE = :UPLOAD_APK_TO_FIR_CUSTOM_VALUE
    end

    class UploadApkToFirAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        # unless params[:app_key]
        #   UI.message("apk_path or app_key can not be empty")
        # end
        # If no APK params were provided, try to fill in the values from lane context, preferring
        # the multiple APKs over the single APK if set.
        if params[:apk_paths].nil? && params[:apk].nil?
          all_apk_paths = Actions.lane_context[SharedValues::GRADLE_ALL_APK_OUTPUT_PATHS] || []
          if all_apk_paths.size > 1
            params[:apk_paths] = all_apk_paths
          else
            params[:apk] = Actions.lane_context[SharedValues::GRADLE_APK_OUTPUT_PATH]
          end
        end
        apk_paths = [params[:apk], params[:apk_paths]].flatten.compact
        apk_paths = [params[:apk]] unless (apk_paths = params[:apk_paths])
        apk_paths.each do | apk |
          flavor = Actions.lane_context[SharedValues::GRADLE_FLAVOR] || /([^\/-]*)(?=-[^\/-]*\.apk$)/.match(apk)
          change_log = "[#{flavor}]+[#{ENV['GIT_BRANCH']}]\r\n---\r\n" + params[:change_log]
          puts "Uploading APK to fir: " + apk
          Actions.sh "sudo /usr/local/bin/fir p '#{apk}' -T '#{params[:app_key]}' -c '#{change_log}'"
        end
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
        [
          FastlaneCore::ConfigItem.new(key: :apk,
                                       description: "Path to the APK file to upload", # a short description of this parameter
                                       conflicting_options: [:apk_paths],
                                       # code_gen_sensitive: true,
                                       # default_value: Dir["*.apk"].last || Dir[File.join("app", "build", "outputs", "apk", "app-Release.apk")].last,
                                       # default_value_dynamic: true,
                                       # is_string: true,
                                       optional: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("Could not find apk file at path '#{value}'") unless File.exist?(value)
                                         UI.user_error!("apk file is not an apk") unless value.end_with?('.apk')
                                       end
                                       ),
          FastlaneCore::ConfigItem.new(key: :apk_paths,
                                       conflicting_options: [:apk],
                                       optional: true,
                                       type: Array,
                                       description: "An array of paths to APK files to upload",
                                       verify_block: proc do |value|
                                         UI.user_error!("Could not evaluate array from '#{value}'") unless value.kind_of?(Array)
                                         value.each do |path|
                                           UI.user_error!("Could not find apk file at path '#{path}'") unless File.exist?(path)
                                           UI.user_error!("file at path '#{path}' is not an apk") unless path.end_with?('.apk')
                                         end
                                       end
                                       ),
          FastlaneCore::ConfigItem.new(key: :app_key,
                                       env_name: "FIR_APP_TOKEN",
                                       description: "Fir token",
                                       is_string: true
                                       ),
          FastlaneCore::ConfigItem.new(key: :change_log,
                                       description: "change log",
                                       is_string: true,
                                       optional: true,
                                       default_value: ""
                                       )
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['UPLOAD_APK_TO_FIR_CUSTOM_VALUE', 'A description of what this value contains']
        ]
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
