require 'spec_helper'

describe Rubyipmi::Ipmitool::ErrorCodes do
  subject {Rubyipmi::Ipmitool::ErrorCodes}

  context "#find_fix" do

    context "auth_error" do

      it 'should raise Rubyipmi::AuthFailed error' do
        result_arr = [
          "Invalid user name\r\nError: Unable to establish LAN session\r\nGet Device ID command failed",
          "RAKP 2 message indicates an error : unauthorized name\r\nError: Unable to establish IPMI v2 / RMCP+ session\r\nUnable to get Chassis Power Status\r\n",
          "Error: Unable to establish IPMI v2 / RMCP+ session\r\nUnable to get Chassis Power Status\r\n",
          "Error: Unable to establish IPMI v2 / RMCP+ session\r\nGet Device ID command failed\r\n",
          "Error: Unable to establish IPMI v2 / RMCP+ session\r\nGet Channel Info command failed\r\nGet Channel Info command failed\r\nGet Channel Info command failed\r\nGet Channel Info command failed\r\nGet Channel Info command failed\r\nGet Channel Info command failed\r\nGet Channel Info command failed\r\nGet Channel Info command failed\r\nGet Channel Info command failed\r\nGet Channel Info command failed\r\nGet Channel Info command failed\r\nGet Channel Info command failed\r\nGet Channel Info command failed\r\nInvalid channel: 255\r\n",
        ]
        result_arr.each do |result|
          expect{ subject.search(result) }.to raise_error(Rubyipmi::AuthFailed)
        end

      end
    end # context auth_error

    context "bmc_hang" do
      it do
        result = "Error in open session response message : insufficient resources for session\n\r\nError: Unable to establish IPMI v2 / RMCP+ session\r\nUnable to get Chassis Power Status\r\n"
        expect{ subject.search(result) }.to raise_error(Rubyipmi::BmcHang)
      end
    end

    context "timeout" do
      it 'should raise timeout' do
        result_arr = [
          "Get Chassis Power Status failed: Timeout\r\nClose Session command failed: Timeout\r\n",
          "Get Chassis Power Status failed: Timeout\r\n",
        ]
        result_arr.each do |result|
          expect{ subject.search(result) }.to raise_error(Rubyipmi::IpmiTimeout)
        end
      end
    end # context timeout

    context "need retry" do
      it do
        result_arr =[
          "ipmitool: lanplus.c:2158: ipmi_lanplus_send_payload: Assertion `session->v2_data.session_state == LANPLUS_STATE_PRESESSION' failed.\n",
          "ipmitool: lanplus.c:2172: ipmi_lanplus_send_payload: Assertion `session->v2_data.session_state == LANPLUS_STATE_OPEN_SESSION_RECEIEVED' failed.\n",
        ]
        result_arr.each do |result|
          expect{ subject.search(result) }.not_to raise_error
        end
      end
    end
  end # context #find_fix
end
