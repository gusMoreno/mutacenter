class GenotipagemsController < ApplicationController
  # GET /genotipagems
  # GET /genotipagems.json
  def index
    @genotipagems = Genotipagem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @genotipagems }
    end
  end

  # GET /genotipagems/1
  # GET /genotipagems/1.json
  def show
    @genotipagem = Genotipagem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @genotipagem }
    end
  end

  # GET /genotipagems/new
  # GET /genotipagems/new.json
  def new
    @genotipagem = Genotipagem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @genotipagem }
    end
  end

  # GET /genotipagems/1/edit
  def edit
    @genotipagem = Genotipagem.find(params[:id])
  end

  # POST /genotipagems
  # POST /genotipagems.json
  def create
    @genotipagem = Genotipagem.new(params[:genotipagem])

    respond_to do |format|
      if @genotipagem.save
        format.html { redirect_to @genotipagem, notice: 'Genotipagem was successfully created.' }
        format.json { render json: @genotipagem, status: :created, location: @genotipagem }
      else
        format.html { render action: "new" }
        format.json { render json: @genotipagem.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /genotipagems/1
  # PUT /genotipagems/1.json
  def update
    @genotipagem = Genotipagem.find(params[:id])

    respond_to do |format|
      if @genotipagem.update_attributes(params[:genotipagem])
        format.html { redirect_to @genotipagem, notice: 'Genotipagem was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @genotipagem.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /genotipagems/1
  # DELETE /genotipagems/1.json
  def destroy
    @genotipagem = Genotipagem.find(params[:id])
    @genotipagem.destroy

    respond_to do |format|
      format.html { redirect_to genotipagems_url }
      format.json { head :no_content }
    end
  end
end
