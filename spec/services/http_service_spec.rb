# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HttpService do
  describe 'tags' do
    before :each do
      Rails.configuration.x.data_to_document_url = 'http://data_to_document_url.ru'
    end

    it { expect { described_class.new }.to_not raise_exception }

    context 'when response status is 200 and empty list' do

      before :each do
        stub_request(:get, 'http://data_to_document_url.ru/api/documents/template_name/tags')
          .to_return(body: { message: 'Ok', tag_list: [] }.to_json, status: 200)
      end

      it { expect { described_class.new.tags!('template_name') }.to_not raise_error }
      it { expect(described_class.new.tags!('template_name')).to eq([]) }
    end

    context 'when response status is 200' do
      let(:response_tag_list) do
        [{ 'name' => 'name1', 'arguments' => '' },
         { 'name' => 'name2', 'arguments' => '(asbarcode=true)'}]
      end

      before :each do
        stub_request(:get, 'http://data_to_document_url.ru/api/documents/template_name/tags')
          .to_return(body: { message: 'Ok', tag_list: response_tag_list }.to_json, status: 200)
      end

      it { expect { described_class.new.tags!('template_name') }.to_not raise_error }
      it { expect(described_class.new.tags!('template_name')).to eq(response_tag_list) }
    end

    context 'when template_name dose not exist' do

      before :each do
        stub_request(:get, 'http://data_to_document_url.ru/api/documents/template_name/tags')
          .to_return(status: 404)
      end

      it { expect { described_class.new.tags!('template_name') }.to raise_error(HttpService::Error) }
    end

    context 'when some error occured' do

      before :each do
        stub_request(:get, 'http://data_to_document_url.ru/api/documents/template_name/tags')
          .to_return(status: 500)
      end

      it { expect { described_class.new.tags!('template_name') }.to raise_error(HttpService::Error) }
    end
  end
end
