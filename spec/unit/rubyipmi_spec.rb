require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe :Rubyipmi do


  before :each do

  end

  it 'is provider installed should return ipmitool true' do
    Rubyipmi.stub(:locate_command).with('ipmitool').and_return('/usr/local/bin/ipmitool')
    Rubyipmi.is_provider_installed?('ipmitool').should be_true
  end

  it 'is locate command should return command in /usr/local/bin' do
    Rubyipmi.stub(:locate_command).with('ipmitool').and_return('/usr/local/bin/ipmitool')
    Rubyipmi.locate_command('ipmitool').should eq('/usr/local/bin/ipmitool')
  end

  it 'is provider installed should return freeipmi true' do
    Rubyipmi.stub(:locate_command).with('ipmipower').and_return('/usr/local/bin/ipmipower')
    Rubyipmi.is_provider_installed?('freeipmi').should be_true
  end

  it 'is provider installed should return error with ipmitool' do
    expect{Rubyipmi.is_provider_installed?('bad_provider')}.to raise_error
  end

  describe Rubyipmi::BaseCommand do

    context "timeout spec" do
      subject{ Rubyipmi::BaseCommand.new('ipmitool') }

      before :each do
        subject.timeout = 0.1
        expect(subject).to receive(:locate_command)
        expect(subject).to receive(:setpass)
        expect(subject).to receive(:removepass)
      end

      it 'should raise IpmiTimeout' do
        expect(subject).to receive(:makecommand).and_return('sleep 2')
        expect{subject.run}.to raise_error(Rubyipmi::IpmiTimeout)
      end

      it 'should not raise error' do
        expect(subject).to receive(:makecommand).and_return('echo foo')
        expect{subject.run}.not_to raise_error
        expect(subject.result).to eq('foo')
      end
    end


  end
end
