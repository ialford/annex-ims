# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  describe 'GET index' do
    xit 'redirects to login' do
      # TODO: need to update to post request
      expect(get(:index)).to redirect_to(user_oktaoauth_omniauth_authorize_path)
    end
  end
end
