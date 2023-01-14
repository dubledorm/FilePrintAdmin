ActiveAdmin.register TemplateInfo do
  permit_params :name, :rus_name, :description, :output_format, :state, :template_id
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

    panel Template.model_name.human do
      attributes_table_for template_info.template do
        row :id
        row :updated_at
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

  controller do
    def template_info_params
      params.required(:template_info).except(:content).permit(:name, :rus_name, :description, :output_format)
    end

    def create
      @resource = TemplateInfoCreateService.call(template_info_params, file_content(params.required(:template_info)[:content]))
      unless @resource.errors.empty?
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
