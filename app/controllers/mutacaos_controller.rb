class MutacaosController < ApplicationController
  # GET /mutacaos
  # GET /mutacaos.json
  def index
    @mutacaos = Mutacao.paginate(:per_page => 10, :page => params[:page], :order => 'sigla asc')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mutacaos }
    end
  end

  # GET /mutacaos/1
  # GET /mutacaos/1.json
  def show
    @mutacao = Mutacao.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mutacao }
    end
  end

  # GET /mutacaos/new
  # GET /mutacaos/new.json
  def new
    @mutacao = Mutacao.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mutacao }
    end
  end

  # GET /mutacaos/1/edit
  def edit
    @mutacao = Mutacao.find(params[:id])
  end

  # POST /mutacaos
  # POST /mutacaos.json
  def create
    @mutacao = Mutacao.new(params[:mutacao])

    respond_to do |format|
      if @mutacao.save
        format.html { redirect_to mutacaos_path, notice: 'Mutacao was successfully created.' }
        format.json { render json: @mutacao, status: :created, location: @mutacao }
      else
        format.html { render action: "new" }
        format.json { render json: @mutacao.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /mutacaos/1
  # PUT /mutacaos/1.json
  def update
    @mutacao = Mutacao.find(params[:id])

    respond_to do |format|
      if @mutacao.update_attributes(params[:mutacao])
        format.html { redirect_to @mutacao, notice: 'Mutacao was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mutacao.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mutacaos/1
  # DELETE /mutacaos/1.json
  def destroy
    @mutacao = Mutacao.find(params[:id])
    @mutacao.destroy

    respond_to do |format|
      format.html { redirect_to mutacaos_url }
      format.json { head :no_content }
    end
  end
end
