# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TemplateInfoCreateService do
  describe 'standart create' do
    let(:good_attributes_example) do
      { name: 'name', rus_name: 'rus name',
        description: 'description', output_format: 'xls' }
    end

    let(:bad_attributes_example) { {} }

    let(:good_content) { '<html>Body</html>' }

    it {
      expect { TemplateInfoCreateService.call(good_attributes_example, good_content) }
        .to change(TemplateInfo, :count).by(1)
    }

    it {
      expect { TemplateInfoCreateService.call(good_attributes_example, good_content) }
        .to change(Template, :count).by(1)
    }

    it 'state should be eq :stable' do
      template_info = TemplateInfoCreateService.call(good_attributes_example, good_content)
      expect(template_info.state).to eq(:stable)
    end

    it {
      expect { TemplateInfoCreateService.call(good_attributes_example, nil) }
        .to change(TemplateInfo, :count).by(0)
    }

    it {
      expect { TemplateInfoCreateService.call(good_attributes_example, nil) }
        .to change(Template, :count).by(0)
    }

    it {
      expect { TemplateInfoCreateService.call(bad_attributes_example, good_content) }
        .to change(TemplateInfo, :count).by(0)
    }

    it {
      expect { TemplateInfoCreateService.call(bad_attributes_example, good_content) }
        .to change(Template, :count).by(0)
    }
  end

  describe 'wrong cases' do
    let(:good_attributes_example) do
      { name: 'name', rus_name: 'rus name',
        description: 'description', output_format: 'xls' }
    end

    let(:good_content) { '<html>Body</html>' }

    context 'when template did not save' do

      before :each do
        allow_any_instance_of(Template).to receive(:persisted?).and_return(false)
      end

      it {
        expect { TemplateInfoCreateService.call(good_attributes_example, good_content) }
          .to change(TemplateInfo, :count).by(0)
      }

      it 'should return error for content field' do
        template_info = TemplateInfoCreateService.call(good_attributes_example, good_content)
        expect(template_info.errors.messages[:content].empty?).to be_falsey
      end

      it 'state should be eq :new' do
        template_info = TemplateInfoCreateService.call(good_attributes_example, good_content)
        expect(template_info.state).to eq(:new)
      end

      it 'should be not persisted' do
        template_info = TemplateInfoCreateService.call(good_attributes_example, good_content)
        expect(template_info.persisted?).to be_falsey
      end
    end
  end
end
