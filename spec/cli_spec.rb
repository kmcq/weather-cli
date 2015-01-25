require 'spec_helper'

describe WeatherCli::Cli do
  before { allow(subject).to receive(:save_default_location).and_return(true) }

  context '::location' do
    let(:location_string) { 'San Francisco, CA' }


    context 'when there are arguments' do
      before do
        allow(subject).to receive(:location_args).and_return(location_string)
        allow(subject).to receive(:user_input).and_return('no')
        allow($stdout).to receive(:write)
      end

      it 'should return the arguments' do
        expect(subject.location).to eq(location_string)
      end
    end

    context 'when there are no arguments' do
      context 'and a default file' do
        before do
          allow(subject).to receive(:config_file).and_return('a_file_name')
          allow(File).to receive(:file?).and_return(true)
          allow(File).to receive(:read).and_return(location_string)
        end

        it 'should return the default file contents' do
          expect(File).to receive(:read).with('a_file_name')
          expect(subject.location).to eq(location_string)
        end
      end

      context 'and no default file' do
        before do
          allow(subject).to receive(:config_file).and_return('not_a_real_file')
          allow(subject).to receive(:user_input).and_return('new default locale')
        end

        it 'should ask for a default location' do
          add_default_message = "Add default location [e.g. San Francisco, CA]:  "
          expect { subject.location }.to output(add_default_message).to_stdout
        end

        it 'should save the default location' do
          allow($stdout).to receive(:write)
          expect(subject).to receive(:save_default_location).with('new default locale')
          subject.location
        end
      end
    end
  end
end
