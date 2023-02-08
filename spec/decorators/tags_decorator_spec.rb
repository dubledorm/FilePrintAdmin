# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagsDecorator do
  describe 'as_template_params_json' do
    context 'when some tags do not exist' do
      let!(:template_info) { FactoryGirl.create :template_info }
      let!(:result) { { template_params: { } } }

      it { expect(TagsDecorator.decorate(template_info.tags).as_template_params_json).to eq(result) }
    end


    context 'when some tags exist' do
      let!(:template_info) { FactoryGirl.create :template_info_with_tags }
      let!(:result) { { template_params: { "#{template_info.tags[0].name}": 'Пример' } } }

      it { expect(TagsDecorator.decorate(template_info.tags).as_template_params_json).to eq(result) }
    end
  end
end
