class PacientesController < ApplicationController
  # GET /pacientes
  # GET /pacientes.json
  def index
    @pacientes = Paciente.paginate(:per_page => 10, :page => params[:page], :order => 'id_amostra asc')

  end

  def busca
    @select = params[:Tipo]

    if @select == "Nome"
      @pacientes = Paciente.find_all_by_nome(params[:search])
    elsif @select == "Codigo"
      @pacientes = Paciente.find_all_by_id_amostra(params[:search].to_i)
    end
    if !@pacientes.empty?
      if @pacientes.count() == 1
        redirect_to(:controller => 'pacientes', :action => 'mostra_busca', :paciente => @pacientes)
      end
    else
      redirect_to pacientes_path, notice: 'Nenhum paciente encontrado.'
    end

  end

  def mostra_busca       #pagina pra mostrar o que foi buscado
    @pac = Paciente.find_by_id(params[:paciente])
    @esq = Esquema.find_all_by_paciente_id(params[:paciente])
    @cd4 = Exame.find_all_by_paciente_id(params[:paciente], :conditions => "tipo = 'CD4'" )
    @cv = Exame.find_all_by_paciente_id(params[:paciente], :conditions => "tipo = 'CV'" )
    @gen = Genotipagem.find_all_by_paciente_id(params[:paciente])
    #TODO interessante ler o arquivo uma vez, e após isso falar onde estao os erros, sem importar nada
    #TODO corigir uniqueness em join table
    #essa parte eh para calcular o tanto de meses que um paciente usou mono terapia e dupla terapia
    #quanto tempo ele ja tomou drogas itrn e a quanto tempo ele esta em tratamento total
    @tempomono = 0
    @tempodupla = 0
    @tempototal = 0
    @tempoitrn = 0
    dataIni = 0
    dataFim = 0
    @esq.each do |e|
      terapia = Medicamento.count(:joins => 'inner join esquemas_medicamentos on medicamentos.id = medicamento_id inner join esquemas on esquemas.id = esquema_id',
                                  :conditions => 'esquema_id = '+e.id.to_s+"and classe = 'ITRN'")
=begin
      if e.DataIni.nil? || e.DataFim.nil? || e.DataIni.blank? || e.DataFim.blank?
        #nao faz nada
      else
        dataIni = e.DataIni[0,4].to_i
        if e.atual == 'S'
          dataFim = Date.current.to_formatted_s(:db).to_s[0,4].to_i
        else
          dataFim = e.DataFim[0,4].to_i
        end
        if terapia > 0
          @tempoitrn += dataFim - dataIni
          if terapia == 1
            @tempomono += dataFim - dataIni
          elsif terapia == 2
            @tempodupla += dataFim - dataIni
          end
        end
        @tempototal += dataFim - dataIni
      end
=end
=begin
      if e.DataIni.nil? || e.DataFim.nil? || e.DataIni.blank? || e.DataFim.blank?
        dataIni = e.DataIni
        if e.atual == 'S'
          dataFim = Date.current.to_formatted_s(:db).to_s
        else
          dataFim = e.DataFim
        end

        if terapia == 1
          if dataIni.length > 4 && dataFim.length > 4
            @tempomono += dataFim.to_date - dataIni.to_date
          else
            @tempomono += (dataFim[0,4].to_i - dataIni[0,4].to_i)*365
          end
        elsif terapia == 2
          if dataIni.length > 4 && dataFim.length > 4
            @tempodupla += dataFim.to_date - dataIni.to_date
          else
            @tempodupla += (dataFim[0,4].to_i - dataIni[0,4].to_i)*365
          end
        end

        if terapia > 0
          if dataIni.length > 4 && dataFim.length > 4
            @tempoitrn += dataFim.to_date - dataIni.to_date
          else
            @tempoitrn += (dataFim[0,4].to_i - dataIni[0,4].to_i)*365
          end
        end

        if dataIni.length > 4 && dataFim.length > 4
          @tempototal += dataFim.to_date - dataIni.to_date
        else
          @tempototal += (dataFim[0,4].to_i - dataIni[0,4].to_i)*365
        end
      end
=end
      if e.DataIni.nil? || e.DataFim.nil? || e.DataIni.blank? || e.DataFim.blank? || e.DataIni.gsub(/[^0-9]/,"").blank? ||e.DataFim.gsub(/[^0-9]/,"").blank?
        #nao faz nada
      else
        dataIni = e.DataIni
        if e.atual == 'S'
          dataFim = Date.current.to_formatted_s(:db).to_s
        else
          dataFim = e.DataFim
        end
        if terapia > 0
          if dataIni.length > 4 && dataFim.length > 4
            @tempoitrn += dataFim.to_date - dataIni.to_date
            if terapia == 1
              @tempomono += dataFim.to_date - dataIni.to_date
            elsif terapia == 2
              @tempodupla += dataFim.to_date - dataIni.to_date
            end
          else
            @tempoitrn += (dataFim[0,4].to_i - dataIni[0,4].to_i)*365
            if terapia == 1
              @tempomono += (dataFim[0,4].to_i - dataIni[0,4].to_i)*365
            elsif terapia == 2
              @tempodupla += (dataFim[0,4].to_i - dataIni[0,4].to_i)*365
            end
          end
        end
        if dataIni.length > 4 && dataFim.length > 4
          @tempototal += dataFim.to_date - dataIni.to_date
        else
          @tempototal += (dataFim[0,4].to_i - dataIni[0,4].to_i)*365
        end
      end

    end
    @tempomono = (@tempomono.to_s.split('/')[0]).to_i/30
    @tempodupla = (@tempodupla.to_s.split('/')[0]).to_i/30
    @tempoitrn = (@tempoitrn.to_s.split('/')[0]).to_i/30
    @tempototal = (@tempototal.to_s.split('/')[0]).to_i/30

    #mostrar quantas mutações de cada tipo o paciente possui em cada genotipagem
    @princip = []
    @poli = []
    @itrn = []
    @itrnn = []
    @poliTR = []
    @gen.each do |g|
      @princip << Mutacao.count(:joins => 'inner join genotipagems_mutacaos on mutacaos.id = mutacao_id inner join genotipagems on genotipagems.id = genotipagem_id',
                                :conditions => 'genotipagem_id = '+g.id.to_s+"and regiao = 'Mutacoes principais'")
      @poli << Mutacao.count(:joins => 'inner join genotipagems_mutacaos on mutacaos.id = mutacao_id inner join genotipagems on genotipagems.id = genotipagem_id',
                             :conditions => 'genotipagem_id = '+g.id.to_s+"and regiao = 'Polimorfismos'")
      @itrn << Mutacao.count(:joins => 'inner join genotipagems_mutacaos on mutacaos.id = mutacao_id inner join genotipagems on genotipagems.id = genotipagem_id',
                             :conditions => 'genotipagem_id = '+g.id.to_s+"and regiao = 'ITRN'")
      @itrnn << Mutacao.count(:joins => 'inner join genotipagems_mutacaos on mutacaos.id = mutacao_id inner join genotipagems on genotipagems.id = genotipagem_id',
                              :conditions => 'genotipagem_id = '+g.id.to_s+"and regiao = 'ITRNN'")
      @poliTR << Mutacao.count(:joins => 'inner join genotipagems_mutacaos on mutacaos.id = mutacao_id inner join genotipagems on genotipagems.id = genotipagem_id',
                               :conditions => 'genotipagem_id = '+g.id.to_s+"and regiao = 'Polimorfismo na TR'")
    end

  end

  # GET /pacientes/1
  # GET /pacientes/1.json
  def show
    @paciente = Paciente.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @paciente }
    end
  end

  # GET /pacientes/new
  # GET /pacientes/new.json
  def new
    @paciente = Paciente.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @paciente }
    end
  end

  # GET /pacientes/1/edit
  def edit
    @paciente = Paciente.find(params[:id])
  end

  # POST /pacientes
  # POST /pacientes.json
  def create
    @paciente = Paciente.new(params[:paciente])

    respond_to do |format|
      if @paciente.save

        format.html { redirect_to(:controller => 'pacientes', :action => 'mostra_busca', :paciente => @paciente) }
        format.json { render json: @paciente, status: :created, location: @paciente }
      else
        format.html { render action: "new" }
        format.json { render json: @paciente.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pacientes/1
  # PUT /pacientes/1.json
  def update
    @paciente = Paciente.find(params[:id])

    respond_to do |format|
      if @paciente.update_attributes(params[:paciente])
        format.html { redirect_to @paciente, notice: 'Paciente was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @paciente.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pacientes/1
  # DELETE /pacientes/1.json
  def destroy
    @paciente = Paciente.find(params[:id])
    @paciente.destroy

    respond_to do |format|
      format.html { redirect_to pacientes_url }
      format.json { head :no_content }
    end
  end
end
