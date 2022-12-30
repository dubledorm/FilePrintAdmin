class PrintingTemplatesController < ApplicationController
  before_action :set_printing_template, only: %i[ show edit update destroy ]

  # GET /printing_templates or /printing_templates.json
  def index
    @printing_templates = PrintingTemplate.all
  end

  # GET /printing_templates/1 or /printing_templates/1.json
  def show
  end

  # GET /printing_templates/new
  def new
    @printing_template = PrintingTemplate.new
  end

  # GET /printing_templates/1/edit
  def edit
  end

  # POST /printing_templates or /printing_templates.json
  def create
    @printing_template = PrintingTemplate.new(printing_template_params)

    respond_to do |format|
      if @printing_template.save
        format.html { redirect_to printingTemplate_url(@printing_template), notice: "Printing template was successfully created." }
        format.json { render :show, status: :created, location: @printing_template }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @printing_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /printing_templates/1 or /printing_templates/1.json
  def update
    respond_to do |format|
      if @printing_template.update(printing_template_params)
        format.html { redirect_to printingTemplate_url(@printing_template), notice: "Printing template was successfully updated." }
        format.json { render :show, status: :ok, location: @printing_template }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @printing_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /printing_templates/1 or /printing_templates/1.json
  def destroy
    @printing_template.destroy

    respond_to do |format|
      format.html { redirect_to printingTemplates_url, notice: "Printing template was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_printing_template
      @printing_template = PrintingTemplate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def printing_template_params
      params.require(:printing_template).permit(:application_type, :name)
    end
end
