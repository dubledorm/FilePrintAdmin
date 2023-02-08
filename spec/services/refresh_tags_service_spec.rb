# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RefreshTagsService do
  describe 'refresh' do
    before :each do
      Rails.configuration.x.data_to_document_url = 'http://data_to_document_url.ru'
    end

    context 'when template_info dose not have any tags' do
      let(:template_info) { FactoryGirl.create :template_info }

      before :each do
        stub_request(:get, "http://data_to_document_url.ru/api/documents/#{template_info.name}/tags")
          .to_return(body: { message: 'Ok', tag_list: [] }.to_json, status: 200)
        described_class.refresh(template_info)
      end

      it { expect(template_info.tags).to eq([]) }
    end

    context 'when template_info have some tags and no tags add' do
      let!(:template_info) { FactoryGirl.create :template_info_with_tags }

      before :each do
        stub_request(:get, "http://data_to_document_url.ru/api/documents/#{template_info.name}/tags")
          .to_return(body: { message: 'Ok', tag_list: [] }.to_json, status: 200)
        described_class.refresh(template_info)
      end

      it { expect(template_info.tags).to eq([]) }
    end

    context 'when template_info have some tags and some tags add' do
      let!(:template_info) { FactoryGirl.create :template_info_with_tags }
      let!(:tag_first_name) { template_info.tags.first.name }
      let(:response_tag_list) do
        [{ 'name' => 'name_1', 'arguments' => '' },
         { 'name' => 'name_2', 'arguments' => '(astable=true)' },
         { 'name' => tag_first_name, 'arguments' => '(asbarcode123=true)' }]
      end

      before :each do
        stub_request(:get, "http://data_to_document_url.ru/api/documents/#{template_info.name}/tags")
          .to_return(body: { message: 'Ok', tag_list: response_tag_list }.to_json, status: 200)
        described_class.refresh(template_info)
      end

      it do
        expect(template_info.tags.map do |tag|
                 { name: tag.name,
                   arg: tag.arguments,
                   descr: tag.description,
                   example: tag.example}
               end).to eq([{ arg: '', descr: '', name: 'name_1', example: '' },
                           { arg: '(astable=true)', descr: '', name: 'name_2', example: '' },
                           { arg: '(asbarcode123=true)', descr: 'Описание', name: tag_first_name, example: 'Пример' }])
      end
    end
  end
end
