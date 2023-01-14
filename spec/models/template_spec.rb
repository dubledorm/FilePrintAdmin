# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Template, type: :model do
  describe 'factory' do
    let!(:template) { FactoryGirl.create :template }

    # Factories
    it { expect(template).to be_valid }
  end
end
