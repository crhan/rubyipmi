module Rubyipmi
  module Ipmitool
    class ErrorCodes

      def self.search(result)
        # Find out what kind of error is happening, parse results
        # Check for authentication or connection issue

        case result
        when /insufficient resources for session/
          raise Rubyipmi::BmcHang, result
        when /Invalid user name|unauthorized name|Unable to establish IPMI v2/
          raise Rubyipmi::AuthFailed, result
        when /lanplus.c/
          true # do nothing, just retry
        when /timeout|timed out/i
          raise Rubyipmi::IpmiTimeout, result
        when /invalid hostname/i
          raise Rubyipmi::InvalidHostname, result
        else
          raise Rubyipmi::UnknownError, result
        end
      end
    end
  end
end

