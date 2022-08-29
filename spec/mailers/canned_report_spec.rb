# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CannedReportMailer, type: :mailer do
=begin
  describe 'email' do
    let(:mail) { CannedReportMailer.email }

    it 'renders the headers' do
      expect(mail.subject).to eq('Ad hoc')
      expect(mail.to).to eq(['to@example.org'])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Hi')
    end
  end
=end
end
