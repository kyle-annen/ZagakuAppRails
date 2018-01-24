require 'rails_helper'
include ControlPanelHelper

RSpec.describe ControlPanelHelper, type: :helper do
  describe 'valid_ical_link' do
    it 'returns true if the ical link is valid' do
      VCR.use_cassette('ical-link-reader') do
        test_link = ENV['GOOGLE_ICAL_LINK']

        result = ControlPanelHelper.valid_ical_link(test_link)

        expect(result).to be_truthy
      end
    end

    it 'returns false if the ical link is invalid' do
      VCR.use_cassette('invalid-ical-link-reader') do
        test_link = 'test'

        result = ControlPanelHelper.valid_ical_link(test_link)

        expect(result).to be_falsey
      end
    end
  end


end

