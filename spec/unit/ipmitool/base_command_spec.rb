require 'spec_helper'

describe Rubyipmi::Ipmitool::BaseCommand do
  subject{ Rubyipmi::Ipmitool::BaseCommand.new('ipmitool') }

  context '#validate_status' do
    it 'should raise Rubyipmi::InvalidExitStatus' do
      exit_status = double(success?: false)
      expect{subject.validate_status(exit_status)}.to raise_error Rubyipmi::InvalidExitStatus
    end

    it 'should return true' do
      exit_status = double(success?: true)
      expect( subject.validate_status(exit_status) ).to be_true
    end
  end

  context "just retry" do
    before :each do
      @result_arr =[
        "ipmitool: lanplus.c:2158: ipmi_lanplus_send_payload: Assertion `session->v2_data.session_state == LANPLUS_STATE_PRESESSION' failed.\n",
        "ipmitool: lanplus.c:2172: ipmi_lanplus_send_payload: Assertion `session->v2_data.session_state == LANPLUS_STATE_OPEN_SESSION_RECEIEVED' failed.\n",
      ]

      subject.stub(:setpass)
      subject.stub(:removepass)
      subject.stub(:locate_command)
    end

    it 'should retry 3 times' do
      expect(Open3).to receive(:popen2e).exactly(3).times do
        subject.instance_variable_set(:@result, @result_arr.sample)
        subject.instance_variable_set(:@exit_status, double(:success? => false))
      end
      expect{subject.run}.to raise_error(Rubyipmi::AutoFixFailed)
    end
  end
end
