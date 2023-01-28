# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TemplateInfoUpdateService do
  describe 'standart update' do
    let(:template) do
      FactoryGirl.create :template, updated_at: Time.now,
                         content: BSON::Binary.new('<html>Body</html>')
    end

    let(:template_info) do
      FactoryGirl.create :template_info, name: 'name', rus_name: 'rus name',
                         description: 'description', output_format: 'xls', template: template
    end

    let(:good_attributes_example) do
      { name: 'name_new', rus_name: 'rus name new',
        description: 'description new', output_format: 'pdf' }
    end

    let(:bad_attributes_example) { {} }

    let(:good_content) { '<html>Body new</html>' }

    it { expect(template_info.template.content.data).to eq('<html>Body</html>') }

    context 'when all records updated' do

      before :each do
        TemplateInfoUpdateService.call(template_info.id, good_attributes_example, good_content)
      end

      it { expect(TemplateInfo.find(template_info.id).template.content.data).to eq('<html>Body new</html>') }
      it { expect(TemplateInfo.find(template_info.id).name).to eq('name_new') }
      it { expect(TemplateInfo.find(template_info.id).rus_name).to eq('rus name new') }
      it { expect(TemplateInfo.find(template_info.id).description).to eq('description new') }
      it { expect(TemplateInfo.find(template_info.id).output_format).to eq(:pdf) }
    end

    context 'when only content updated' do

      before :each do
        TemplateInfoUpdateService.call(template_info.id, {}, good_content)
      end

      it { expect(TemplateInfo.find(template_info.id).template.content.data).to eq('<html>Body new</html>') }
      it { expect(TemplateInfo.find(template_info.id).name).to eq('name') }
      it { expect(TemplateInfo.find(template_info.id).rus_name).to eq('rus name') }
      it { expect(TemplateInfo.find(template_info.id).description).to eq('description') }
      it { expect(TemplateInfo.find(template_info.id).output_format).to eq(:xls) }
    end

    context 'when only template_infos updated' do

      before :each do
        TemplateInfoUpdateService.call(template_info.id, good_attributes_example, nil)
      end

      it { expect(TemplateInfo.find(template_info.id).template.content.data).to eq('<html>Body</html>') }
      it { expect(TemplateInfo.find(template_info.id).name).to eq('name_new') }
      it { expect(TemplateInfo.find(template_info.id).rus_name).to eq('rus name new') }
      it { expect(TemplateInfo.find(template_info.id).description).to eq('description new') }
      it { expect(TemplateInfo.find(template_info.id).output_format).to eq(:pdf) }
    end
  end
end
