class WebservicesController < ApplicationController
  before_action :set_webservice, only: [:show, :edit, :update, :destroy]

  # GET /webservices
  # GET /webservices.json
  def index
    @webservices = Webservice.all
  end

  # GET /webservices/1
  # GET /webservices/1.json
  def show
  end

  # GET /webservices/new
  def new
    @webservice = Webservice.new
  end

  # GET /webservices/1/edit
  def edit
  end

  # POST /webservices
  # POST /webservices.json
  def create
    @webservice = Webservice.new(webservice_params)

    respond_to do |format|
      if @webservice.save
        format.html { redirect_to @webservice, notice: 'Webservice was successfully created.' }
        format.json { render :show, status: :created, location: @webservice }
      else
        format.html { render :new }
        format.json { render json: @webservice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /webservices/1
  # PATCH/PUT /webservices/1.json
  def update
    respond_to do |format|
      if @webservice.update(webservice_params)
        format.html { redirect_to @webservice, notice: 'Webservice was successfully updated.' }
        format.json { render :show, status: :ok, location: @webservice }
      else
        format.html { render :edit }
        format.json { render json: @webservice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /webservices/1
  # DELETE /webservices/1.json
  def destroy
    @webservice.destroy
    respond_to do |format|
      format.html { redirect_to webservices_url, notice: 'Webservice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_webservice
      @webservice = Webservice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def webservice_params
      params[:webservice]
    end
end
