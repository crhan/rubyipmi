require 'rubyipmi/ipmitool/errorcodes'

module Rubyipmi::Ipmitool

  class BaseCommand < Rubyipmi::BaseCommand

    def setpass
      super
      @options["f"] = @passfile.path
      @passfile.write "#{@options["P"]}"
      @passfile.rewind
      @passfile.close
    end

    def max_retry_count
      3
    end

    def makecommand
      args = ''
      # need to format the options to ipmitool format
      @options.each do  |k,v|
        # must remove from command line as its handled via conf file
        next if k == "P"
        next if k == "cmdargs"
        args << " -#{k} #{v}"
      end

      # since ipmitool requires commands to be in specific order

      args << ' ' + options.fetch('cmdargs', '')

      return "#{cmd} #{args.lstrip}"
    end

    # The findfix method acts like a recursive method and applies fixes defined in the errorcodes
    # If a fix is found it is applied to the options hash, and then the last run command is retried
    # until all the fixes are exhausted or a error not defined in the errorcodes is found
    def find_fix(result)
      ErrorCodes.search(result)
    end

  end # class BaseCommand
end # class Rubyipmi::Ipmitool
