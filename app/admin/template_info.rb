ActiveAdmin.register TemplateInfo do

  permit_params :name, :rus_name, :description, :output_format, :state, :template_id,
                options_attributes: %i[page_size orientation page_height page_width header_html footer_html]
  menu label: TemplateInfo.model_name.human

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
      end
    end

    panel Tag.model_name.human do
      attributes_table_for template_info do
        render 'admin/template_infos/print_tags', template_info: template_info
      end
    end
  end


  form title: TemplateInfo.model_name.human do |f|
    f.semantic_errors *f.object.errors.keys
    inputs I18n.t('admin_menu.attributes') do
      f.input :name
      f.input :rus_name
      f.input :description
      f.input :output_format, collection: TemplateInfo::OUTPUT_FORMAT_VALUES.map { |item| [item, item] }
      panel TemplateOption.model_name.human do
      end
      f.fields_for :options, @resource.options do |options_form|
        options_form.input :page_size, collection: TemplateOption::PAGE_SIZE_VALUES.map { |item| [item, item] }.sort
        options_form.input :orientation, collection: TemplateOption::ORIENTATION_VALUES.map { |item| [item, item] }
        options_form.input :page_width
        options_form.input :page_height
        options_form.input :header_html, as: :text
        options_form.input :footer_html, as: :text
      end
      panel Margin.model_name.human do
      end
      f.fields_for '[options][margins]', @resource.options&.margins do |margin_form|
        margin_form.input :left
        margin_form.input :right
        margin_form.input :top
        margin_form.input :bottom
      end
    end

    inputs Template.model_name.human do
      f.input :content, as: :file
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

  controller do
    def template_info_params
      params.required(:template_info).except(:content).permit(:name, :rus_name, :description,
                                                              :output_format,
                                                              options: [:page_size, :orientation, :page_height,
                                                                        :page_width, :header_html, :footer_html,
                                                                        margins: %i[left right top bottom]])
    end

    def create
      @resource = TemplateInfoCreateService.call(template_info_params,
                                                 file_content(params.required(:template_info)[:content]))
      unless @resource&.errors&.empty?
        render :new
        return
      end

      redirect_to admin_template_info_path(@resource.id)
    end

    def update
      @resource = TemplateInfoUpdateService.call(params[:id],
                                                 template_info_params,
                                                 file_content(params.required(:template_info)[:content]))
      unless @resource.errors.empty?
        render :edit
        return
      end

      redirect_to admin_template_info_path(@resource.id)
    end

    private

    def file_content(uploaded_file)
      return nil if uploaded_file.blank?
      File.open(uploaded_file.tempfile.path, 'rb', &:read)
    end
  end
end
