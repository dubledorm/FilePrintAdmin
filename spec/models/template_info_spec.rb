# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TemplateInfo, type: :model do
  describe 'factory' do
    let!(:template_info) { FactoryGirl.create :template_info }

    # Factories
    it { expect(template_info).to be_valid }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:rus_name) }
    it { should validate_presence_of(:output_format) }
    it { should belong_to(:template) }

    it { expect(described_class.new({}).valid?).to_not be_truthy }
    it { expect(described_class.new(name: 'name', rus_name: 'rus_name', state: :new, output_format: :xls).valid?).to be_truthy }
    it { expect(described_class.new(name: 'name', rus_name: 'rus_name', state: :stable, output_format: :xls).valid?).to be_truthy }
  end
end
