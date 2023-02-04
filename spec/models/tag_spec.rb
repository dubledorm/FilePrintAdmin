# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'factory' do
    let(:tag) { FactoryGirl.create :tag }

    # Factories
    it { expect(tag).to be_valid }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should belong_to(:template_info) }
  end

  describe 'name uniqueness' do
    let!(:template_info) { FactoryGirl.create :template_info }
    let!(:template_info1) { FactoryGirl.create :template_info }
    let!(:tag1) { FactoryGirl.create :tag, template_info: template_info, name: 'name1' }

    it { expect(Tag.new(name: 'name1', template_info: template_info).valid?).to be_falsey }
    it { expect(Tag.new(name: 'name2', template_info: template_info).valid?).to be_truthy }
    it { expect(Tag.new(name: 'name1', template_info: template_info1).valid?).to be_truthy }
  end
end
