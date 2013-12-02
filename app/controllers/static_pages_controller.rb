class StaticPagesController < ApplicationController
  def home
  end

  def help

    #preenchimento da lista de mutações
    @muta = Mutacao.all(:select => 'regiao, sigla', :order => 'sigla asc')

    @listaMutacao = []
    @muta.each do |mu|
    @listaMutacao << mu.sigla + ' - ' + mu.regiao
    end

    if params[:commit]
      puts 'comitou'
      if params[:drogas].nil?
        flash.now[:notice] = "Nenhuma droga foi escolhida para pesquisa"
      elsif params[:mutacao].nil?
        flash.now[:notice] = "Nenhuma mutacao foi escolhida para pesquisa"
      else
        i=1
        med = "'"+params[:drogas][0].to_s+"'"
        while i<params[:drogas].length
          med += " , '"+params[:drogas][i].to_s+"'"
          i=i+1
        end
        med += ') and ('
        #j=1
        #mut = "'"+params[:mutacao][0].to_s+"'"
        #while j<params[:mutacao].length
        #  mut += ", '"+params[:mutacao][j].to_s+"'"
        #  j=j+1
        #end

        j=1  #(sigla = '100I' and regiao = 'ITRNN') or (sigla = '100L' and regiao = 'Polimorfismo na TR') )
        aux = params[:mutacao][0].gsub(' ', '').split('-')
        mut = "( sigla = '"+aux[0]+"' and regiao = '"+aux[1]+"' )"
        while j<params[:mutacao].length
          aux = params[:mutacao][j].gsub(' ', '').split('-')
          mut += " or ( sigla = '"+aux[0]+"' and regiao = '"+aux[1]+"' )"
          j=j+1
        end
        mut += ' )'

        interval = " * interval '365 days'"
        if params[:idadeMinima].blank? && params[:idadeMaxima].blank? #se nao tiver nenhuma data preenchida procura todos
          if params[:sexo] == 'Masculino'
            puts 'entrou na pesquisa'
=begin
            @pac = Paciente.all(:joins => 'inner join esquemas e on pacientes.id = e.paciente_id
                                     inner join esquemas_medicamentos em on e.id = em.esquema_id
                                     inner join medicamentos m on m.id = em.medicamento_id
                                     inner join genotipagems g on pacientes.id = g.paciente_id
                                     inner join genotipagems_mutacaos gm on g.id = gm.genotipagem_id
                                     inner join mutacaos mu on mu.id = gm.mutacao_id',
                                :conditions => 'abreviacao IN ('+med+') and sigla IN ('+mut+")
                                and pacientes.genero = 'M'",
                                :group => 'pacientes.id')
=end

            @pac = Paciente.all(:joins => 'inner join esquemas e on pacientes.id = e.paciente_id
                                     inner join esquemas_medicamentos em on e.id = em.esquema_id
                                     inner join medicamentos m on m.id = em.medicamento_id
                                     inner join genotipagems g on pacientes.id = g.paciente_id
                                     inner join genotipagems_mutacaos gm on g.id = gm.genotipagem_id
                                     inner join mutacaos mu on mu.id = gm.mutacao_id',
                                :conditions => 'abreviacao IN ('+med + mut + "
                                and pacientes.genero = 'M'",
                                :order => 'pacientes.id_amostra',
                                :group => 'pacientes.id')
          elsif params[:sexo] == 'Feminino'
            @pac = Paciente.all(:joins => 'inner join esquemas e on pacientes.id = e.paciente_id
                                     inner join esquemas_medicamentos em on e.id = em.esquema_id
                                     inner join medicamentos m on m.id = em.medicamento_id
                                     inner join genotipagems g on pacientes.id = g.paciente_id
                                     inner join genotipagems_mutacaos gm on g.id = gm.genotipagem_id
                                     inner join mutacaos mu on mu.id = gm.mutacao_id',
                                :conditions => 'abreviacao IN ('+med + mut + "
                                and pacientes.genero = 'F'",
                                :order => 'pacientes.id_amostra',
                                :group => 'pacientes.id')
          elsif params[:sexo] == ''
            @pac = Paciente.all(:joins => 'inner join esquemas e on pacientes.id = e.paciente_id
                                     inner join esquemas_medicamentos em on e.id = em.esquema_id
                                     inner join medicamentos m on m.id = em.medicamento_id
                                     inner join genotipagems g on pacientes.id = g.paciente_id
                                     inner join genotipagems_mutacaos gm on g.id = gm.genotipagem_id
                                     inner join mutacaos mu on mu.id = gm.mutacao_id',
                                :conditions => 'abreviacao IN ('+med + mut,
                                :order => 'pacientes.id_amostra',
                                :group => 'pacientes.id')

          end
        elsif !params[:idadeMinima].blank? && !params[:idadeMaxima].blank? #se tiver as duas datas preenchidas
          if params[:sexo] == 'Masculino'
            @pac = Paciente.all(:joins => 'inner join esquemas e on pacientes.id = e.paciente_id
                                     inner join esquemas_medicamentos em on e.id = em.esquema_id
                                     inner join medicamentos m on m.id = em.medicamento_id
                                     inner join genotipagems g on pacientes.id = g.paciente_id
                                     inner join genotipagems_mutacaos gm on g.id = gm.genotipagem_id
                                     inner join mutacaos mu on mu.id = gm.mutacao_id',
                                :conditions => 'abreviacao IN ('+med + mut + '
                                and (now()-pacientes."dataNasc"::date) >= '+params[:idadeMinima]+interval+'
                                and (now()-pacientes."dataNasc"::date) <= '+params[:idadeMaxima]+interval+"
                                and pacientes.genero = 'M'",
                                :order => 'pacientes.id_amostra',
                                :group => 'pacientes.id')
          elsif params[:sexo] == 'Feminino'
            @pac = Paciente.all(:joins => 'inner join esquemas e on pacientes.id = e.paciente_id
                                     inner join esquemas_medicamentos em on e.id = em.esquema_id
                                     inner join medicamentos m on m.id = em.medicamento_id
                                     inner join genotipagems g on pacientes.id = g.paciente_id
                                     inner join genotipagems_mutacaos gm on g.id = gm.genotipagem_id
                                     inner join mutacaos mu on mu.id = gm.mutacao_id',
                                :conditions => 'abreviacao IN ('+med + mut + '
                                and (now()-pacientes."dataNasc"::date) >= '+params[:idadeMinima]+interval+'
                                and (now()-pacientes."dataNasc"::date) <= '+params[:idadeMaxima]+interval+"
                                and pacientes.genero = 'F'",
                                :order => 'pacientes.id_amostra',
                                :group => 'pacientes.id')
          elsif params[:sexo] == ''
            @pac = Paciente.all(:joins => 'inner join esquemas e on pacientes.id = e.paciente_id
                                     inner join esquemas_medicamentos em on e.id = em.esquema_id
                                     inner join medicamentos m on m.id = em.medicamento_id
                                     inner join genotipagems g on pacientes.id = g.paciente_id
                                     inner join genotipagems_mutacaos gm on g.id = gm.genotipagem_id
                                     inner join mutacaos mu on mu.id = gm.mutacao_id',
                                :conditions => 'abreviacao IN ('+med + mut + '
                                and (now()-pacientes."dataNasc"::date) >= '+params[:idadeMinima]+interval+'
                                and (now()-pacientes."dataNasc"::date) <= '+params[:idadeMaxima]+interval,
                                :order => 'pacientes.id_amostra',
                                :group => 'pacientes.id')
          end
        elsif (params[:idadeMinima].blank? && !params[:idadeMaxima].blank?) || (!params[:idadeMinima].blank? && params[:idadeMaxima].blank?)
          flash.now[:notice] = "Nao e possivel preencher apenas um campo de data"
        end

        # para cada paciente, pegar seus esquemas e para cada esquema fazer as contas necessarias (parecido com o mostra_busca)
        @total = [] #recebe o tempo total de tratamento de cada paciente encontrado na busca
        @itrn = []
        @mono = []
        @dupla = []

        @mutprincip = []
        @mutpoli = []
        @mutitrn = []
        @mutitrnn = []
        @mutpoliTR = []

        @pac.each do |p|
          @esq = Esquema.find_all_by_paciente_id(p.id)
          @gen = Genotipagem.find_all_by_paciente_id(p.id)

          total = 0
          itrn = 0
          mono = 0
          dupla = 0
          dataIni = 0
          dataFim = 0
          @esq.each do |e|
            terapia = Medicamento.count(:joins => 'inner join esquemas_medicamentos on medicamentos.id = medicamento_id inner join esquemas on esquemas.id = esquema_id',
                                        :conditions => 'esquema_id = '+e.id.to_s+" and classe = 'ITRN'")
            if e.DataIni.nil? || e.DataFim.nil? || e.DataIni.blank? || e.DataFim.blank? || e.DataIni.gsub(/[^0-9]/,'').blank? || e.DataIni.gsub(/[^0-9]/,'').blank?
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
                  itrn += dataFim.to_date - dataIni.to_date
                  if terapia == 1
                    mono += dataFim.to_date - dataIni.to_date
                  elsif terapia == 2
                    dupla += dataFim.to_date - dataIni.to_date
                  end
                else
                  itrn += (dataFim[0,4].to_i - dataIni[0,4].to_i)*365
                  if terapia == 1
                    mono += (dataFim[0,4].to_i - dataIni[0,4].to_i)*365
                  elsif terapia == 2
                    dupla += (dataFim[0,4].to_i - dataIni[0,4].to_i)*365
                  end
                end
              end
              if dataIni.length > 4 && dataFim.length > 4
                total += dataFim.to_date - dataIni.to_date
              else
                total += (dataFim[0,4].to_i - dataIni[0,4].to_i)*365
              end
            end

          end

          @total << (total.to_s.split('/')[0]).to_i/30
          @itrn << (itrn.to_s.split('/')[0]).to_i/30
          @mono << (mono.to_s.split('/')[0]).to_i/30
          @dupla << (dupla.to_s.split('/')[0]).to_i/30

          princip = [] #contem a quantidade de mutações principais em cada exame de genotipagem de cada paciente
          poli = []
          itrn = []
          itrnn = []
          poliTR = []
          @gen.each do |g|
            princip << Mutacao.count(:joins => 'inner join genotipagems_mutacaos on mutacaos.id = mutacao_id inner join genotipagems on genotipagems.id = genotipagem_id',
                                     :conditions => 'genotipagem_id = '+g.id.to_s+" and regiao = 'Mutacoes principais'")
            poli << Mutacao.count(:joins => 'inner join genotipagems_mutacaos on mutacaos.id = mutacao_id inner join genotipagems on genotipagems.id = genotipagem_id',
                                  :conditions => 'genotipagem_id = '+g.id.to_s+" and regiao = 'Polimorfismos'")
            itrn << Mutacao.count(:joins => 'inner join genotipagems_mutacaos on mutacaos.id = mutacao_id inner join genotipagems on genotipagems.id = genotipagem_id',
                                  :conditions => 'genotipagem_id = '+g.id.to_s+" and regiao = 'ITRN'")
            itrnn << Mutacao.count(:joins => 'inner join genotipagems_mutacaos on mutacaos.id = mutacao_id inner join genotipagems on genotipagems.id = genotipagem_id',
                                   :conditions => 'genotipagem_id = '+g.id.to_s+" and regiao = 'ITRNN'")
            poliTR << Mutacao.count(:joins => 'inner join genotipagems_mutacaos on mutacaos.id = mutacao_id inner join genotipagems on genotipagems.id = genotipagem_id',
                                    :conditions => 'genotipagem_id = '+g.id.to_s+" and regiao = 'Polimorfismo na TR'")
          end
          @mutprincip << princip.to_s.gsub(/[^0-9]/, '').to_i
          @mutpoli << poli.to_s.gsub(/[^0-9]/, '').to_i
          @mutitrn << itrn.to_s.gsub(/[^0-9]/, '').to_i
          @mutitrnn << itrnn.to_s.gsub(/[^0-9]/, '').to_i
          @mutpoliTR << poliTR.to_s.gsub(/[^0-9]/, '').to_i
        end

        if @pac.size > 0
          @mediatotal = (@total.reduce :+) / @total.length
          @mediaitrn = (@itrn.reduce :+) / @itrn.length
          @mediamono = (@mono.reduce :+) / @mono.length
          @mediadupla = (@dupla.reduce :+) / @dupla.length
          @mediamutprincip = (@mutprincip.reduce :+) / @mutprincip.length
          @mediamutpoli = (@mutpoli.reduce :+) / @mutpoli.length
          @mediamutitrn = (@mutitrn.reduce :+) / @mutitrn.length
          @mediamutitrnn = (@mutitrnn.reduce :+) / @mutitrnn.length
          @mediamutpoliTR = (@mutpoliTR.reduce :+) / @mutpoliTR.length
        else
          flash.now[:notice] = 'Nenhum paciente se enquadra nos paramentros buscados'
        end
      end
    end
  end

  def about
  end

  def contact

  	@user=User.find_all_by_email(params[:email])


  end
  
  def import

  @header
  if (!params[:file].nil? && params[:file].present?)
    import_test(params[:file])

    if Pacienteerro.count > 0
      puts 'vai exportar'
      redirect_to '/exportarErros.xls'
      puts 'exportou!!!!'

    else
      flash.now[:success] = "Arquivo importado com sucesso."
    end
  end
  else
    #flash.now[:error] = "Arquivo nao encontrado."
  end

  def export  #exporta o banco correto inteiro
    @columns  = []
    @columns[0] = Paciente.order(:id_amostra)
    @columns[1] = Genotipagem.order()
    @columns[2] = Esquema.order(:paciente_id).group_by &:paciente_id
    @pacients = Paciente.order(:id_amostra)
    @variables = []

    respond_to do |format|
      format.html
      format.csv { send_data @columns.to_csv }
      format.xls # { send_data @products.to_csv(col_sep: "\t") }
    end
  end

  def exportarErros  #exporta o banco de erros inteiro
    @columns  = []
    @columns[0] = Pacienteerro.order(:id_amostra)
    #@columns[0] = Pacienteerro.order.all(:conditions=> "antigo = 'N'")
    @columns[1] = Genotipagemerro.order()
    @columns[2] = Esquemaerro.order(:paciente_id).group_by &:paciente_id
    @pacients = Pacienteerro.order(:id_amostra)
    #@pacients = Pacienteerro.order.all(:conditions=> "antigo = 'N'")
    @variables = []

    respond_to do |format|
      format.html
      format.csv { send_data @columns.to_csv }
      format.xls # { send_data @products.to_csv(col_sep: "\t") }
    end
    flash.now[:alert] = "Arquivo importado parcialmente, foi exportado um excel com os erros encontrados."
    Esquemaerro.delete_all
    Medicamentoerro.delete_all
    Exameerro.delete_all
    Genotipagemerro.delete_all
    Mutacaoerro.delete_all
    Pacienteerro.delete_all
  end

  def exportMDR  #exporta os pacientes que possuem mutações 67DEL, 69INS, 151M
    @columns  = []
    @columns[0] = Paciente.order.all(:joins => 'inner join genotipagems g on pacientes.id = g.paciente_id
                                                    inner join genotipagems_mutacaos gm on g.id = gm.genotipagem_id
                                                    inner join mutacaos mu on mu.id = gm.mutacao_id',
                                     :conditions => "sigla IN('67DEL', '69INS', '151M')",
                                     :group=> 'pacientes.id')
    @columns[1] = Genotipagem.order()
    @columns[2] = Esquema.order(:paciente_id).group_by &:paciente_id
    @pacients = Paciente.order.all(:joins => 'inner join genotipagems g on pacientes.id = g.paciente_id
                                                    inner join genotipagems_mutacaos gm on g.id = gm.genotipagem_id
                                                    inner join mutacaos mu on mu.id = gm.mutacao_id',
                                   :conditions => "sigla IN('67DEL', '69INS', '151M')",
                                   :group=> 'pacientes.id')
    @variables = []

    respond_to do |format|
      format.html
      format.csv { send_data @columns.to_csv }
      format.xls # { send_data @products.to_csv(col_sep: "\t") }
    end
  end

  def exportITRN  #exporta os pacientes que usam/usaram alguma droga do tipo ITRN
    @columns  = []
    @columns[0] = Paciente.order.all(:joins => 'inner join esquemas e on pacientes.id = e.paciente_id
                                                inner join esquemas_medicamentos em on e.id = em.esquema_id
                                                inner join medicamentos m on m.id = em.medicamento_id',
                                     :conditions => "classe = 'ITRN'",
                                     :group=> 'pacientes.id')
    @columns[1] = Genotipagem.order()
    @columns[2] = Esquema.order(:paciente_id).group_by &:paciente_id
    @pacients = Paciente.order.all(:joins => 'inner join esquemas e on pacientes.id = e.paciente_id
                                                inner join esquemas_medicamentos em on e.id = em.esquema_id
                                                inner join medicamentos m on m.id = em.medicamento_id',
                                   :conditions => "classe = 'ITRN'",
                                   :group=> 'pacientes.id')
    @variables = []

    respond_to do |format|
      format.html
      format.csv { send_data @columns.to_csv }
      format.xls # { send_data @products.to_csv(col_sep: "\t") }
    end
  end

  def exportITRNN  #exporta os pacientes que usam/usaram alguma droga do tipo ITRNN
    @columns  = []
    @columns[0] = Paciente.order.all(:joins => 'inner join esquemas e on pacientes.id = e.paciente_id
                                                inner join esquemas_medicamentos em on e.id = em.esquema_id
                                                inner join medicamentos m on m.id = em.medicamento_id',
                                     :conditions => "classe = 'ITRNN'",
                                     :group=> 'pacientes.id')
    @columns[1] = Genotipagem.order()
    @columns[2] = Esquema.order(:paciente_id).group_by &:paciente_id
    @pacients = Paciente.order.all(:joins => 'inner join esquemas e on pacientes.id = e.paciente_id
                                                inner join esquemas_medicamentos em on e.id = em.esquema_id
                                                inner join medicamentos m on m.id = em.medicamento_id',
                                   :conditions => "classe = 'ITRNN'",
                                   :group=> 'pacientes.id')
    @variables = []

    respond_to do |format|
      format.html
      format.csv { send_data @columns.to_csv }
      format.xls # { send_data @products.to_csv(col_sep: "\t") }
    end
  end

end