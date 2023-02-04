# frozen_string_literal: true

ActiveAdmin.register TemplateInfo do
  permit_params :name, :rus_name, :description, :output_format, :state, :template_id,
                template_attributes: %i[id content updated_at],
                options_attributes: [:id, :page_size, :orientation, :page_height, :page_width,
                                     :header_html, :footer_html,
                                     margins: %i[id top bottom left right]],
                tags_attributes: %i[id name arguments description example _destroy]
  menu label: TemplateInfo.model_name.human
  filter :name
  filter :rus_name
  filter :output_format, as: :check_boxes,
         collection: proc { TemplateInfo::OUTPUT_FORMAT_VALUES.map { |item| [item, item.to_s] } }

  index do
    selectable_column
    column :id
    column :name
    column :rus_name
    column :output_format
    column :description
    actions
  end

  show do
    panel TemplateInfo.model_name.human do
      attributes_table_for template_info do
        row :name
        row :rus_name
        row :description
        row :output_format
        row :state
      end
    end

    if resource.output_format == :pdf
      panel TemplateOption.model_name.human do
        attributes_table_for template_info.options do
          row :page_size
          row :orientation
          row :page_width
          row :page_height
          row :header_html
          row :footer_html
        end
      end

      panel Margin.model_name.human do
        attributes_table_for template_info.options&.margins do
          row :left
          row :right
          row :top
          row :bottom
        end
      end
    end

    panel Template.model_name.human do
      attributes_table_for template_info.template do
        row :id
        row :updated_at
        row :original_file_name
      end
    end

    panel Tag.model_name.human do
      table_for template_info.tags do
        column :name
        column :arguments
        column :description
        column :example
      end
    end
  end


  form decorate: true, title: TemplateInfo.model_name.human do |f|
    f.semantic_errors *f.object.errors.keys
    inputs I18n.t('admin_menu.attributes') do
      f.input :name
      f.input :rus_name
      f.input :description
      f.input :output_format, collection: TemplateInfo::OUTPUT_FORMAT_VALUES.map { |item| [item, item] },
                              input_html: { onchange: "select_output_type(this.value)" }
      inputs TemplateOption.model_name.human, id: 'input_options',
                                              style: "display: #{resource.decorate.display_options? ? 'block' : 'none'}" do
        f.fields_for :options, @resource.options do |options_form|
          options_form.input :page_size, collection: TemplateOption::PAGE_SIZE_VALUES.map { |item| [item, item] }.sort
          options_form.input :orientation, collection: TemplateOption::ORIENTATION_VALUES.map { |item| [item, item] }
          options_form.input :page_width
          options_form.input :page_height
          options_form.input :header_html, as: :text
          options_form.input :footer_html, as: :text
        end
      end
      inputs Margin.model_name.human, id: 'input_margins',
                                      style: "display: #{resource.decorate.display_options? ? 'block' : 'none'}" do
        f.fields_for '[options_attributes][margins]', @resource.options&.margins do |margin_form|
          margin_form.input :left
          margin_form.input :right
          margin_form.input :top
          margin_form.input :bottom
        end
      end
    end

    inputs Template.model_name.human do
      f.fields_for :template do |template_form|
        template_form.input :content, as: :file
      end
    end

    f.inputs do
      f.has_many :tags, allow_destroy: true do |tag_form|
        tag_form.input :name
        tag_form.input :arguments
        tag_form.input :description
        tag_form.input :example
      end
    end

    f.actions
  end

  member_action :download_template, method: :get do
    send_data resource.template.content.data, filename: resource.decorate.template_file_name, disposition: 'attachment'
  end

  action_item :download, only: :show do
    link_to "DownloadTemplate", download_template_admin_template_info_path(id: resource.id), method: :get
  end

  member_action :refresh_tags, method: :post do
    RefreshTagsService.refresh(resource)
    redirect_to admin_template_info_path(id: resource.id)
  end


  action_item :refresh_tags, only: :show do
    link_to "RefreshTags", refresh_tags_admin_template_info_path(id: resource.id), method: :post
  end
end
