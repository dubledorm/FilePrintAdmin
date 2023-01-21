# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TemplateInfo, type: :model do
  describe 'factory' do
    let!(:template_info) { FactoryGirl.create :template_info }
    let!(:template_info_with_options) { FactoryGirl.create :template_info_with_options }

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

    it { expect(template_info_with_options).to be_valid }
    it {
      expect(described_class.new(name: 'name', rus_name: 'rus_name', state: :new, output_format: :xls,
                                 options: { page_size: :A4 }).valid?).to be_truthy
    }

    it 'should create record with template_options' do
      instance = described_class.create(name: 'name', rus_name: 'rus_name', state: :new, output_format: :xls,
                                        options: { page_size: :A4 })

      expect(instance.persisted?).to be_truthy

      instance = described_class.find(instance.id)
      expect(instance.options.page_size).to eq(:A4)
    end

    it 'should create record with template_options and margins' do
      instance = described_class.create(name: 'name', rus_name: 'rus_name', state: :new, output_format: :xls,
                                        options: { page_size: :A4,
                                                   margins: { left: 0, right: 1 }})

      expect(instance.persisted?).to be_truthy

      instance = described_class.find(instance.id)
      expect(instance.options.page_size).to eq(:A4)
      expect(instance.options.margins.left).to eq(0)
      expect(instance.options.margins.right).to eq(1)
    end
  end
end
