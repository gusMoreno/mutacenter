class EsquemasController < ApplicationController
  # GET /esquemas
  # GET /esquemas.json
  def index
    @esquemas = Esquema.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @esquemas }
    end
  end

  # GET /esquemas/1
  # GET /esquemas/1.json
  def show
    @esquema = Esquema.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @esquema }
    end
  end

  # GET /esquemas/new
  # GET /esquemas/new.json
  def new
    @esquema = Esquema.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @esquema }
    end
  end

  # GET /esquemas/1/edit
  def edit
    @esquema = Esquema.find(params[:id])
  end

  # POST /esquemas
  # POST /esquemas.json
  def create
    @esquema = Esquema.new(params[:esquema])

    respond_to do |format|
      if @esquema.save
        format.html { redirect_to @esquema, notice: 'Esquema was successfully created.' }
        format.json { render json: @esquema, status: :created, location: @esquema }
      else
        format.html { render action: "new" }
        format.json { render json: @esquema.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /esquemas/1
  # PUT /esquemas/1.json
  def update
    @esquema = Esquema.find(params[:id])

    respond_to do |format|
      if @esquema.update_attributes(params[:esquema])
        format.html { redirect_to @esquema, notice: 'Esquema was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @esquema.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /esquemas/1
  # DELETE /esquemas/1.json
  def destroy
    @esquema = Esquema.find(params[:id])
    @esquema.destroy

    respond_to do |format|
      format.html { redirect_to esquemas_url }
      format.json { head :no_content }
    end
  end
end
