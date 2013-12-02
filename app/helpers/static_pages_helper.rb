module StaticPagesHelper

  #@novasMut = 0

  def open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
      when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
      when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def import_test(file)
    spreadsheet = open_spreadsheet(file)
    @header = spreadsheet.row(1)
    @row1
    count = 0
    @columns = {}
    @header[0].split(";").each do |f|
      array=[]
      (3..spreadsheet.last_row).each do |i|  #gets the column value and puts into array
        value = spreadsheet.row(i).split(";")[count]
        @row1 = value
        array.push(value)

      end
      count += 1
      @columns.merge!(f => array )
      #atualiza_mut_med #cadastra as mutações encontradas
      #cadastra_importacao
      importar
    end
  end

  def importar
    i = 0
    existe = 0
    novo = 0
    erro = 0
    while i< @columns['ID amostra'].length
      celula = @columns['ID amostra'][i]
      break if celula[0].nil? #sai do while se nao tiver nada na coluna idAmostra

      #contadores de teste
      if verificacaoArquivo(celula)
        if verificaExistencia(celula[0].to_i)
          existe = existe + 1
          puts 'EXISTENTE'
          puts
          geno = 'nao'
          unless Genotipagem.find_by_dataColeta(celula[6])
            principais(celula)
            polimorfismos(celula)
            itrn(celula)
            itrnn(celula)
            polimorfismosTR(celula)
            geno = 'sim'
          end
          pac = Paciente.find_by_id_amostra(celula[0].to_i).id
          importarEmExistente(celula, pac, geno)
        else
          novo = novo + 1
          puts 'NOVO'
          puts
          principais(celula)
          polimorfismos(celula)
          itrn(celula)
          itrnn(celula)
          polimorfismosTR(celula)
          importarComoNovo(celula)
        end
      else
        erro = erro + 1
        puts 'ERRO'
        puts
        principaisErro(celula)
        polimorfismosErro(celula)
        itrnErro(celula)
        itrnnErro(celula)
        polimorfismosTRErro(celula)
        medicamentosErro(celula)
        importarComoErro(celula)
      end

      i = i+1
      puts 'existe = '+existe.to_s
      puts 'novo = '+novo.to_s
      puts 'erro = '+erro.to_s
    end
  end

  def verificacaoArquivo(cell)

    #if !cell[2].nil?
      #dataNasc = cell[2].to_s.split('-')
     # puts 'dataNasc ' + cell[2].to_s
      #return false unless dataNasc[2].gsub(/[^0-9]/,'').length == 2 && dataNasc[1].gsub(/[^0-9]/,'').length == 2 && dataNasc[0].gsub(/[^0-9]/,'').length == 4
      return false unless /\d{4}\-\d{2}\-\d{2}/.match(cell[2].to_s)
    #end

    if !cell[6].nil? || !cell[7].nil?
      puts 'coleta e recepcao'
      #coleta =  cell[6].to_s.split('-')
      #recepcao =  cell[7].to_s.split('-')
      #return false unless cell[6].to_s.to_date <= cell[7].to_s.to_date && coleta[2].gsub(/[^0-9]/,'').length == 2 && coleta[1].gsub(/[^0-9]/,'').length == 2 && coleta[0].gsub(/[^0-9]/,'').length == 4 && recepcao[2].gsub(/[^0-9]/,'').length == 2 && recepcao[1].gsub(/[^0-9]/,'').length == 2 && recepcao[0].gsub(/[^0-9]/,'').length == 4
      begin
        return false unless cell[6].to_s.to_date <= cell[7].to_s.to_date && /\d{4}\-\d{2}\-\d{2}/.match(cell[6].to_s) && /\d{4}\-\d{2}\-\d{2}/.match(cell[7].to_s)
      rescue Exception => e
        puts e.message
        return false
      end

      #return false if cell[6].to_s.length!=10 || cell[7].to_s.length!=10
      #return false unless cell[6].to_s.to_date <= cell[7].to_s.to_date && /\d{4}\-\d{2}\-\d{2}/.match(cell[6].to_s) && /\d{4}\-\d{2}\-\d{2}/.match(cell[7].to_s)

    end

    cont = 0
    while cont < 10
      if !cell[10 + cont*3].nil?
        puts 'Esquema ' +(cont+1).to_s

        #verificação dos medicamentos
        droga = cell[10 + cont*3].to_s.split('+')
        d=0
        while(d < droga.length)
          if(!droga[d].eql?(''))
            puts 'Droga ' + droga[d].strip
            return false unless Medicamento.find_by_abreviacao(droga[d].strip)
          end
          d=d+1
        end
=begin
        return false if cell[(8 + cont*3)].nil? || cell[(9 + cont*3)].nil?
        if cell[(9 + cont*3)].eql?('atual')
          puts 'ATUAL'
          puts 'cell8 '+cell[(8 + cont*3)].to_s
          #inicial =  cell[(8 + cont*3)].to_s.split('-')
          #return false unless cell[(8 + cont*3)].to_s.to_date <= Date.current && inicial[2].gsub(/[^0-9]/,'').length == 2 && inicial[1].gsub(/[^0-9]/,'').length == 2 && inicial[0].gsub(/[^0-9]/,'').length == 4

          return false unless cell[(8 + cont*3)].to_s.to_date <= Date.current && /\d{4}\-\d{2}\-\d{2}/.match(cell[(8 + cont*3)].to_s)
        else
          puts 'NAO ATUAL'
          puts 'cell8 '+cell[(8 + cont*3)].to_s
          puts 'cell9 '+cell[(9 + cont*3)].to_s
          #return false if
          #inicial =  cell[(8 + cont*3)].to_s.split('-')
          #final =  cell[(9 + cont*3)].to_s.split('-')

          #return false unless cell[(8 + cont*3)].to_s.to_date <= cell[(9 + cont*3)].to_s.to_date && inicial[2].gsub(/[^0-9]/,'').length == 2 && inicial[1].gsub(/[^0-9]/,'').length == 2 && inicial[0].gsub(/[^0-9]/,'').length == 4 && final[2].gsub(/[^0-9]/,'').length == 2 && final[1].gsub(/[^0-9]/,'').length == 2 && final[0].gsub(/[^0-9]/,'').length == 4
          return false if cell[(8 + cont*3)].to_s.length!=10 || cell[(9 + cont*3)].to_s.length!=10
          return false unless cell[(8 + cont*3)].to_s.to_date <= cell[(9 + cont*3)].to_s.to_date && /\d{4}\-\d{2}\-\d{2}/.match(cell[(8 + cont*3)].to_s) && /\d{4}\-\d{2}\-\d{2}/.match(cell[(9 + cont*3)].to_s)
        end
=end
        begin
          if cell[(9 + cont*3)].eql?('atual')
            puts 'ATUAL'
            puts 'cell8 '+cell[(8 + cont*3)].to_s
            return false unless cell[(8 + cont*3)].to_s.to_date <= Date.current && /\d{4}\-\d{2}\-\d{2}/.match(cell[(8 + cont*3)].to_s)
          else
            puts 'NAO ATUAL'
            puts 'cell8 '+cell[(8 + cont*3)].to_s
            puts 'cell9 '+cell[(9 + cont*3)].to_s
            return false unless cell[(8 + cont*3)].to_s.to_date <= cell[(9 + cont*3)].to_s.to_date && /\d{4}\-\d{2}\-\d{2}/.match(cell[(8 + cont*3)].to_s) && /\d{4}\-\d{2}\-\d{2}/.match(cell[(9 + cont*3)].to_s)
          end
        rescue Exception => e
          puts e.message
          return false
        end
        cont = cont+1
      else
        break
      end
    end

    cont = 0
    while cont<3
      if !cell[(43 + cont*3)].nil?
        #return false if cell[(45 + cont*3)].nil?
        puts 'DATA Carga viral'
        puts 'cell45 '+cell[(45 + cont*3)].to_s
        #data = cell[(45 + cont*3)].to_s.split('-')

        #return false unless data[2].gsub(/[^0-9]/,'').length == 2 && data[1].gsub(/[^0-9]/,'').length == 2 && data[0].gsub(/[^0-9]/,'').length == 4
        begin
          return false unless /\d{4}\-\d{2}\-\d{2}/.match(cell[(45 + cont*3)].to_s)
        rescue Exception => e
          puts e.message
          return false
        end
      end
      cont = cont+1
    end

    cont = 0
    while cont<4
      if !cell[(52 + cont*2)].nil?
        #return false if cell[(53 + cont*2)].nil?

        puts 'DATA CD4'
        puts 'cell53 '+cell[(53 + cont*2)].to_s
        #data = cell[(53 + cont*2)].to_s.split('-')
        #return false unless data[2].gsub(/[^0-9]/,'').length == 2 && data[1].gsub(/[^0-9]/,'').length == 2 && data[0].gsub(/[^0-9]/,'').length == 4
        begin
          return false unless /\d{4}\-\d{2}\-\d{2}/.match(cell[(53 + cont*2)].to_s)
        rescue Exception => e
          puts e.message
          return false
        end
      end
      cont = cont+1
    end

    #validação das mutações
    array = []
    array2 = []
    if !cell[38].nil?
      array.concat(cell[38].split('/'))
    end
    if !cell[39].nil?
      array.concat(cell[39].split('/'))
    end
    if !cell[40].nil?
      array.concat(cell[40].split('/'))
    end
    if !cell[41].nil?
      array.concat(cell[41].split('/'))
    end
    if !cell[42].nil?
      array.concat(cell[42].split('/'))
    end

    p=0
    while p<array.length
      array2 << array[p].split(' ')
      p=p+1
    end
    p=0
    array = []
    while p<array2.length
      array.concat(array2[p])
      p=p+1
    end

    p=0
    num = ""
    while p<array.length
      if /[^0-9]/.match(array[p]) && array[p].length == 1  #se for so uma letra
        puts 'mutacao = '+ (num + array[p])
        #return false unless (num + array[p]).eql?((num + array[p]).gsub(/[^a-zA-Z0-9]/, ''))

        #return false unless /[a-zA-Z]{0,1}[0-9]{1,3}[a-zA-Z]{1}/.match(num + array[p]) && (num + array[p]).eql?((num + array[p]).gsub(/[^a-zA-Z0-9]/, ''))

        return false if verificaMutacao(num+array[p])==false
      else
        puts 'mutacao = '+ (array[p])
        #return false unless (array[p]).eql?((array[p]).gsub(/[^a-zA-Z0-9]/, ''))
        num = array[p].gsub(/[^0-9]/, '')
        #return false unless /[a-zA-Z]{0,1}[0-9]{1,3}[a-zA-Z]{1}/.match(array[p]) && (array[p]).eql?((array[p]).gsub(/[^a-zA-Z0-9]/, ''))
        return false if verificaMutacao(array[p])==false
      end
      p=p+1
    end

    return true
  end

  def verificaMutacao(palavra) #ultimo caractere tem que ser uma letra e o resto todos numeros
    puts 'entrou'
    return false if palavra.length < 2 || palavra.length > 4
    return false if /[^a-zA-Z0-9 ]/.match(palavra)
    return false unless /[0-9]/.match(palavra.first(palavra.length-1))
    return false unless /[a-zA-Z]/.match(palavra[palavra.length-1])
    puts 'OK'
  end

  def verificaExistencia(numero)  #se retornar true, deve ir para a funcao de cadastro de dados em paciente ja existente
    if Paciente.find_by_id_amostra(numero) #se for id que já existe, adiciona no paciente existente
      return true
    else
      return false
    end
  end

  def importarComoNovo(celula)
    Paciente.create(id_amostra: celula[0].to_i, nome: celula[1], dataNasc: celula[2].to_s, prontuario: celula[3], genero: celula[4])
    pac = Paciente.find_by_id_amostra(celula[0].to_i).id # para pegar o id do q foi cadastrado e usar de chave estrangeira

    #fazer carga viral e CD4
    if !celula[43].nil?
      Exame.create(tipo: 'CV', data: celula[45].to_s, valor: celula[43].to_s.gsub(/[<>]/, '').to_i, sinal: celula[43].to_s.gsub(/[0-9]/, ''), paciente_id: pac)
    end
    if !celula[46].nil?
      Exame.create(tipo: 'CV', data: celula[48].to_s, valor: celula[46].to_s.gsub(/[<>]/, '').to_i, sinal: celula[46].to_s.gsub(/[0-9]/, ''), paciente_id: pac)
    end
    if !celula[49].nil?
      Exame.create(tipo: 'CV', data: celula[51].to_s, valor: celula[49].to_s.gsub(/[<>]/, '').to_i, sinal: celula[49].to_s.gsub(/[0-9]/, ''), paciente_id: pac)
    end

    if !celula[52].nil?
      Exame.create(tipo: 'CD4', data: celula[53].to_s, valor: celula[52].to_s.gsub(/[<>]/, '').to_i, sinal: celula[52].to_s.gsub(/[0-9]/, ''), paciente_id: pac)
    end
    if !celula[54].nil?
      Exame.create(tipo: 'CD4', data: celula[55].to_s, valor: celula[54].to_s.gsub(/[<>]/, '').to_i, sinal: celula[54].to_s.gsub(/[0-9]/, ''), paciente_id: pac)
    end
    if !celula[56].nil?
      Exame.create(tipo: 'CD4', data: celula[57].to_s, valor: celula[56].to_s.gsub(/[<>]/, '').to_i, sinal: celula[56].to_s.gsub(/[0-9]/, ''), paciente_id: pac)
    end
    if !celula[58].nil?
      Exame.create(tipo: 'CD4', data: celula[59].to_s, valor: celula[58].to_s.gsub(/[<>]/, '').to_i, sinal: celula[58].to_s.gsub(/[0-9]/, ''), paciente_id: pac)
    end

    #esquema
    cont = 0
    while(cont < 10)
      if(!celula[10 + cont*3].nil?)
        droga = celula[10 + cont*3].to_s.split('+')
        if(celula[(10 + cont*3)-1].eql?('atual'))
          Esquema.create(DataIni: celula[(10 + cont*3)-2].to_s, atual:'S', paciente_id: pac)
        else
          Esquema.create(DataIni: celula[(10 + cont*3)-2].to_s, DataFim: celula[(10 + cont*3)-1].to_s, atual:'N', paciente_id: pac)
        end

        d = 0
        esquema_id = Esquema.last
        while(d < droga.length)
          if(!droga[d].eql?(''))
            med = Medicamento.find_by_abreviacao(droga[d].strip)
            esquema_id.medicamentos<<med
          end
          d=d+1
        end
        cont = cont+1
      else
        break
      end
    end


    #genotipagem
    possui = true
    if celula[38].nil? && celula[39].nil? && celula[40].nil? && celula[41].nil? && celula[42].nil? #se nao tiver nenhuma mutacao cadastrada
      #Genotipagem.create(localProcedencia: 'ai ai ai q merda q eu to fazendo', paciente_id: pac)
      possui = false
    end

    if !celula[5].nil? #se possui local de procedencia
      if celula[6].nil? #dataColeta vazia
        if celula[7].nil? #dataRecep vazia
          Genotipagem.create(localProcedencia: celula[5], paciente_id: pac)
        else #dataRecep nao vazia
          Genotipagem.create(localProcedencia: celula[5], dataRecep: celula[7].to_s, paciente_id: pac)
        end
      else #dataColeta nao vazia
        if celula[7].nil? #dataRecep cheia
          Genotipagem.create(localProcedencia: celula[5], dataColeta: celula[6].to_s, paciente_id: pac)
        else #dataRecep vazia
          Genotipagem.create(localProcedencia: celula[5], dataColeta: celula[6].to_s, dataRecep: celula[7].to_s, paciente_id: pac)
        end
      end
    else #nao possui local de procedencia
      unless possui == false # a nao ser que nao possua mutacoes cadastradas faça
        if celula[6].nil? #dataColeta vazia
          if celula[7].nil? #dataRecep vazia
            Genotipagem.create(localProcedencia: 'nao possui', paciente_id: pac)
          else #dataRecep nao vazia
            Genotipagem.create(localProcedencia: 'nao possui', dataRecep: celula[7].to_s, paciente_id: pac)
          end
        else #dataColeta nao vazia
          if celula[7].nil? #dataRecep vazia
            Genotipagem.create(localProcedencia: 'nao possui', dataColeta: celula[6].to_s, paciente_id: pac)
          else #dataRecep nao vazia
            Genotipagem.create(localProcedencia: 'nao possui', dataColeta: celula[6].to_s, dataRecep: celula[7].to_s, paciente_id: pac)
          end
        end
      end
    end

    #mutacao
    #array2 = []
    if !celula[38].nil?
      array = []
      array.concat(celula[38].split('/'))
      referenciaMut(array, 'Mutacoes principais')
    end
    if !celula[39].nil?
      array = []
      array.concat(celula[39].split('/'))
      referenciaMut(array, 'Polimorfismos')
    end
    if !celula[40].nil?
      array = []
      array.concat(celula[40].split('/'))
      referenciaMut(array, 'ITRN')
    end
    if !celula[41].nil?
      array = []
      array.concat(celula[41].split('/'))
      referenciaMut(array, 'ITRNN')
    end
    if !celula[42].nil?
      array = []
      array.concat(celula[42].split('/'))
      referenciaMut(array, 'Polimorfismo na TR')
    end
  end

  def importarEmExistente(celula, pac, geno)

    #fazer carga viral e CD4
    if !celula[43].nil?
      Exame.create(tipo: 'CV', data: celula[45].to_s, valor: celula[43].to_s.gsub(/[<>]/, '').to_i, sinal: celula[43].to_s.gsub(/[0-9]/, ''), paciente_id: pac)
    end
    if !celula[46].nil?
      Exame.create(tipo: 'CV', data: celula[48].to_s, valor: celula[46].to_s.gsub(/[<>]/, '').to_i, sinal: celula[46].to_s.gsub(/[0-9]/, ''), paciente_id: pac)
    end
    if !celula[49].nil?
      Exame.create(tipo: 'CV', data: celula[51].to_s, valor: celula[49].to_s.gsub(/[<>]/, '').to_i, sinal: celula[49].to_s.gsub(/[0-9]/, ''), paciente_id: pac)
    end

    if !celula[52].nil?
      Exame.create(tipo: 'CD4', data: celula[53].to_s, valor: celula[52].to_s.gsub(/[<>]/, '').to_i, sinal: celula[52].to_s.gsub(/[0-9]/, ''), paciente_id: pac)
    end
    if !celula[54].nil?
      Exame.create(tipo: 'CD4', data: celula[55].to_s, valor: celula[54].to_s.gsub(/[<>]/, '').to_i, sinal: celula[54].to_s.gsub(/[0-9]/, ''), paciente_id: pac)
    end
    if !celula[56].nil?
      Exame.create(tipo: 'CD4', data: celula[57].to_s, valor: celula[56].to_s.gsub(/[<>]/, '').to_i, sinal: celula[56].to_s.gsub(/[0-9]/, ''), paciente_id: pac)
    end
    if !celula[58].nil?
      Exame.create(tipo: 'CD4', data: celula[59].to_s, valor: celula[58].to_s.gsub(/[<>]/, '').to_i, sinal: celula[58].to_s.gsub(/[0-9]/, ''), paciente_id: pac)
    end

    #esquema
    cont = 0
    while(cont < 10)
      if(!celula[10 + cont*3].nil?)
        droga = celula[10 + cont*3].to_s.split('+')
        if(celula[(10 + cont*3)-1].eql?('atual'))
          Esquema.create(DataIni: celula[(10 + cont*3)-2].to_s, atual:'S', paciente_id: pac)
        else
          Esquema.create(DataIni: celula[(10 + cont*3)-2].to_s, DataFim: celula[(10 + cont*3)-1].to_s, atual:'N', paciente_id: pac)
        end

        d = 0
        esquema_id = Esquema.last
        while(d < droga.length)
          if(!droga[d].eql?(''))
            med = Medicamento.find_by_abreviacao(droga[d].strip)
            esquema_id.medicamentos<<med
          end
          d=d+1
        end
        cont = cont+1
      else
        break
      end
    end

    if geno = 'sim' #se for uma nova genotipagem
      #genotipagem
      possui = true
      if celula[38].nil? && celula[39].nil? && celula[40].nil? && celula[41].nil? && celula[42].nil? #se nao tiver nenhuma mutacao cadastrada
                                                                                                     #Genotipagem.create(localProcedencia: 'ai ai ai q merda q eu to fazendo', paciente_id: pac)
        possui = false
      end

      if !celula[5].nil? #se possui local de procedencia
        if celula[6].nil? #dataColeta vazia
          if celula[7].nil? #dataRecep vazia
            Genotipagem.create(localProcedencia: celula[5], paciente_id: pac)
          else #dataRecep nao vazia
            Genotipagem.create(localProcedencia: celula[5], dataRecep: celula[7].to_s, paciente_id: pac)
          end
        else #dataColeta nao vazia
          if celula[7].nil? #dataRecep cheia
            Genotipagem.create(localProcedencia: celula[5], dataColeta: celula[6].to_s, paciente_id: pac)
          else #dataRecep vazia
            Genotipagem.create(localProcedencia: celula[5], dataColeta: celula[6].to_s, dataRecep: celula[7].to_s, paciente_id: pac)
          end
        end
      else #nao possui local de procedencia
        unless possui == false # a nao ser que nao possua mutacoes cadastradas faça
          if celula[6].nil? #dataColeta vazia
            if celula[7].nil? #dataRecep vazia
              Genotipagem.create(localProcedencia: 'nao possui', paciente_id: pac)
            else #dataRecep nao vazia
              Genotipagem.create(localProcedencia: 'nao possui', dataRecep: celula[7].to_s, paciente_id: pac)
            end
          else #dataColeta nao vazia
            if celula[7].nil? #dataRecep vazia
              Genotipagem.create(localProcedencia: 'nao possui', dataColeta: celula[6].to_s, paciente_id: pac)
            else #dataRecep nao vazia
              Genotipagem.create(localProcedencia: 'nao possui', dataColeta: celula[6].to_s, dataRecep: celula[7].to_s, paciente_id: pac)
            end
          end
        end
      end

      #mutacao
      if !celula[38].nil?
        array = []
        array.concat(celula[38].split('/'))
        referenciaMut(array, 'Mutacoes principais')
      end
      if !celula[39].nil?
        array = []
        array.concat(celula[39].split('/'))
        referenciaMut(array, 'Polimorfismos')
      end
      if !celula[40].nil?
        array = []
        array.concat(celula[40].split('/'))
        referenciaMut(array, 'ITRN')
      end
      if !celula[41].nil?
        array = []
        array.concat(celula[41].split('/'))
        referenciaMut(array, 'ITRNN')
      end
      if !celula[42].nil?
        array = []
        array.concat(celula[42].split('/'))
        referenciaMut(array, 'Polimorfismo na TR')
      end
    end
  end

  def importarComoErro(celula)
    Pacienteerro.create(id_amostra: celula[0].to_i, nome: celula[1], dataNasc: celula[2].to_s, prontuario: celula[3], genero: celula[4])
    pac = Pacienteerro.find_by_id_amostra(celula[0].to_i).id # para pegar o id do q foi cadastrado e usar de chave estrangeira

    #fazer carga viral e CD4
    if !celula[43].nil?
      Exameerro.create(tipo: 'CV', data: celula[45].to_s, valor: celula[43].to_s.gsub(/[<>]/, '').to_i, sinal: celula[43].to_s.gsub(/[0-9]/, '') , paciente_id: pac)
    end
    if !celula[46].nil?
      Exameerro.create(tipo: 'CV', data: celula[48].to_s, valor: celula[46].to_s.gsub(/[<>]/, '').to_i, sinal: celula[46].to_s.gsub(/[0-9]/, ''), paciente_id: pac)
    end
    if !celula[49].nil?
      Exameerro.create(tipo: 'CV', data: celula[51].to_s, valor: celula[49].to_s.gsub(/[<>]/, '').to_i, sinal: celula[49].to_s.gsub(/[0-9]/, ''), paciente_id: pac)
    end

    if !celula[52].nil?
      Exameerro.create(tipo: 'CD4', data: celula[53].to_s, valor: celula[52].to_s.gsub(/[<>]/, '').to_i, sinal: celula[52].to_s.gsub(/[0-9]/, ''), paciente_id: pac)
    end
    if !celula[54].nil?
      Exameerro.create(tipo: 'CD4', data: celula[55].to_s, valor: celula[54].to_s.gsub(/[<>]/, '').to_i, sinal: celula[54].to_s.gsub(/[0-9]/, ''), paciente_id: pac)
    end
    if !celula[56].nil?
      Exameerro.create(tipo: 'CD4', data: celula[57].to_s, valor: celula[56].to_s.gsub(/[<>]/, '').to_i, sinal: celula[56].to_s.gsub(/[0-9]/, ''), paciente_id: pac)
    end
    if !celula[58].nil?
      Exameerro.create(tipo: 'CD4', data: celula[59].to_s, valor: celula[58].to_s.gsub(/[<>]/, '').to_i, sinal: celula[58].to_s.gsub(/[0-9]/, ''), paciente_id: pac)
    end

    #esquema
    cont = 0
    while(cont < 10)
      if(!celula[10 + cont*3].nil?)
        droga = celula[10 + cont*3].to_s.split('+')
        if(celula[(10 + cont*3)-1].eql?('atual'))
          Esquemaerro.create(DataIni: celula[(10 + cont*3)-2].to_s, atual:'S', paciente_id: pac)
        else
          Esquemaerro.create(DataIni: celula[(10 + cont*3)-2].to_s, DataFim: celula[(10 + cont*3)-1].to_s, atual:'N', paciente_id: pac)
        end

        d = 0
        esquema_id = Esquemaerro.last
        while(d < droga.length)
          if(!droga[d].eql?(''))
            med = Medicamentoerro.find_by_abreviacao(droga[d].strip)
            esquema_id.medicamentoerros<<med
          end
          d=d+1
        end
        cont = cont+1
      else
        break
      end
    end

    #genotipagem
    possui = true
    if celula[38].nil? && celula[39].nil? && celula[40].nil? && celula[41].nil? && celula[42].nil? #se nao tiver nenhuma mutacao cadastrada
      #Genotipagemerro.create(localProcedencia: 'ai ai ai q merda q eu to fazendo', paciente_id: pac)
      possui = false
    end

    if !celula[5].nil? #se possui local de procedencia
      if celula[6].nil? #dataColeta vazia
        if celula[7].nil? #dataRecep vazia
          Genotipagemerro.create(localProcedencia: celula[5], paciente_id: pac)
        else #dataRecep nao vazia
          Genotipagemerro.create(localProcedencia: celula[5], dataRecep: celula[7].to_s, paciente_id: pac)
        end
      else #dataColeta nao vazia
        if celula[7].nil? #dataRecep cheia
          Genotipagemerro.create(localProcedencia: celula[5], dataColeta: celula[6].to_s, paciente_id: pac)
        else #dataRecep vazia
          Genotipagemerro.create(localProcedencia: celula[5], dataColeta: celula[6].to_s, dataRecep: celula[7].to_s, paciente_id: pac)
        end
      end
    else #nao possui local de procedencia
      unless possui == false # a nao ser que nao possua mutacoes cadastradas faça
        if celula[6].nil? #dataColeta vazia
          if celula[7].nil? #dataRecep vazia
            Genotipagemerro.create(localProcedencia: 'nao possui', paciente_id: pac)
          else #dataRecep nao vazia
            Genotipagemerro.create(localProcedencia: 'nao possui', dataRecep: celula[7].to_s, paciente_id: pac)
          end
        else #dataColeta nao vazia
          if celula[7].nil? #dataRecep vazia
            Genotipagemerro.create(localProcedencia: 'nao possui', dataColeta: celula[6].to_s, paciente_id: pac)
          else #dataRecep nao vazia
            Genotipagemerro.create(localProcedencia: 'nao possui', dataColeta: celula[6].to_s, dataRecep: celula[7].to_s, paciente_id: pac)
          end
        end
      end
    end

    #mutacao
    if !celula[38].nil?
      array = []
      array.concat(celula[38].split('/'))
      referenciaMutErro(array, 'Mutacoes principais')
    end
    if !celula[39].nil?
      array = []
      array.concat(celula[39].split('/'))
      referenciaMutErro(array, 'Polimorfismos')
    end
    if !celula[40].nil?
      array = []
      array.concat(celula[40].split('/'))
      referenciaMutErro(array, 'ITRN')
    end
    if !celula[41].nil?
      array = []
      array.concat(celula[41].split('/'))
      referenciaMutErro(array, 'ITRNN')
    end
    if !celula[42].nil?
      array = []
      array.concat(celula[42].split('/'))
      referenciaMutErro(array, 'Polimorfismo na TR')
    end
  end


=begin
  def cadastra_importacao
    i = 0
    while i< @columns['ID amostra'].length
      celula = @columns['ID amostra'][i]
      break if celula[0].nil? #sai do while se nao tiver nada na coluna idAmostra



      Paciente.create(id_amostra: celula[0].to_i, nome: celula[1], dataNasc: celula[2].to_s, prontuario: celula[3], genero: celula[4])
      pac = Paciente.find_by_id_amostra(celula[0].to_i).id # para pegar o id do q foi cadastrado e usar de chave estrangeira

      #fazer carga viral e CD4
      if !celula[43].nil?
        Exame.create(tipo: 'CV', data: celula[45].to_s, valor: celula[43].to_s.gsub(/[<>]/, '').to_i, paciente_id: pac)
      end
      if !celula[46].nil?
        Exame.create(tipo: 'CV', data: celula[48].to_s, valor: celula[46].to_s.gsub(/[<>]/, '').to_i, paciente_id: pac)
      end
      if !celula[49].nil?
        Exame.create(tipo: 'CV', data: celula[51].to_s, valor: celula[49].to_s.gsub(/[<>]/, '').to_i, paciente_id: pac)
      end

      if !celula[52].nil?
        Exame.create(tipo: 'CD4', data: celula[53].to_s, valor: celula[52].to_s.gsub(/[<>]/, '').to_i, paciente_id: pac)
      end
      if !celula[54].nil?
        Exame.create(tipo: 'CD4', data: celula[55].to_s, valor: celula[54].to_s.gsub(/[<>]/, '').to_i, paciente_id: pac)
      end
      if !celula[56].nil?
        Exame.create(tipo: 'CD4', data: celula[57].to_s, valor: celula[56].to_s.gsub(/[<>]/, '').to_i, paciente_id: pac)
      end
      if !celula[58].nil?
        Exame.create(tipo: 'CD4', data: celula[59].to_s, valor: celula[58].to_s.gsub(/[<>]/, '').to_i, paciente_id: pac)
      end

      #esquema
      cont = 0
      while(cont < 10)
        if(!celula[10 + cont*3].nil?)
          droga = celula[10 + cont*3].to_s.split('+')
          if(celula[(10 + cont*3)-1].eql?('atual'))
            Esquema.create(DataIni: celula[(10 + cont*3)-2].to_s, atual:'S', paciente_id: pac)
          else
            Esquema.create(DataIni: celula[(10 + cont*3)-2].to_s, DataFim: celula[(10 + cont*3)-1].to_s, atual:'N', paciente_id: pac)
          end

          d = 0
          esquema_id = Esquema.last
          while(d < droga.length)
            if(!droga[d].eql?(''))
              med = Medicamento.find_by_abreviacao(droga[d].strip)
              esquema_id.medicamentos<<med
              d=d+1
            end
          end
          cont = cont+1
        else
          break
        end
      end

      #genotipagem
      possui = true
      if celula[38].nil? && celula[39].nil? && celula[40].nil? && celula[41].nil? && celula[42].nil? #se nao tiver nenhuma mutacao cadastrada
        Genotipagem.create(localProcedencia: 'nao possui', paciente_id: pac)
        possui = false
      end

      if !celula[5].nil? #se possui local de procedencia
        if celula[6].nil? #dataColeta vazia
          if celula[7].nil? #dataRecep vazia
            Genotipagem.create(localProcedencia: celula[5], paciente_id: pac)
          else #dataRecep nao vazia
            Genotipagem.create(localProcedencia: celula[5], dataRecep: celula[7].to_s, paciente_id: pac)
          end
        else #dataColeta nao vazia
          if celula[7].nil? #dataRecep cheia
            Genotipagem.create(localProcedencia: celula[5], dataColeta: celula[6].to_s, paciente_id: pac)
          else #dataRecep vazia
            Genotipagem.create(localProcedencia: celula[5], dataColeta: celula[6].to_s, dataRecep: celula[7].to_s, paciente_id: pac)
          end
        end
      else #nao possui local de procedencia
        unless possui == false # a nao ser que nao possua mutacoes cadastradas faça
          if celula[6].nil? #dataColeta vazia
            if celula[7].nil? #dataRecep vazia
              Genotipagem.create(localProcedencia: 'nao possui', paciente_id: pac)
            else #dataRecep nao vazia
              Genotipagem.create(localProcedencia: 'nao possui', dataRecep: celula[7].to_s, paciente_id: pac)
            end
          else #dataColeta nao vazia
            if !celula[7].nil? #dataRecep vazia
              Genotipagem.create(localProcedencia: 'nao possui', dataColeta: celula[6].to_s, paciente_id: pac)
            else #dataRecep nao vazia
              Genotipagem.create(localProcedencia: 'nao possui', dataColeta: celula[6].to_s, dataRecep: celula[7].to_s, paciente_id: pac)
            end
          end
        end
      end

      #mutacao
      array = []
      array2 = []
      if !celula[38].nil?
        array.concat(celula[38].split('/'))
      end
      if !celula[39].nil?
        array.concat(celula[39].split('/'))
      end
      if !celula[40].nil?
        array.concat(celula[40].split('/'))
      end
      if !celula[41].nil?
        array.concat(celula[41].split('/'))
      end
      if !celula[42].nil?
        array.concat(celula[42].split('/'))
      end

      p=0
      while p<array.length
        array2 << array[p].split(' ')
        p=p+1
      end
      p=0
      array = []
      while p<array2.length
        array.concat(array2[p])
        p=p+1
      end

      p=0
      num = ""
      gen_id = Genotipagem.last
      while p<array.length
        if /[^0-9]/.match(array[p]) && array[p].length == 1  #se for so uma letra
          mut = Mutacao.find_by_sigla(num + array[p])
        else
          mut = Mutacao.find_by_sigla(array[p])
          num = array[p].gsub(/[^0-9]/, '')
        end
        gen_id.mutacaos<<mut
        p=p+1
      end
      i = i+1
    end
    flash.now[:success] = "Arquivo importado com sucesso"
  end
=end



  ###############################################################################################################
  #metodos para inserir mutacoes na tabela Mutacaos (pegando as q estao no excel)

  #end num = "14K".gsub(/[^0-9]/, '')  >>> num fica valendo "14"
=begin
  def atualiza_mut_med #atualiza o banco com as novas mutações e novos medicamentos encontrados no excel que esta sendo importado

    @novasMut = 0
    x=0
    while x< @columns['ID amostra'].length
      celula = @columns['ID amostra'][x]

      principais(celula)
      polimorfismos(celula)
      itrn(celula)
      itrnn(celula)
      polimorfismosTR(celula)
      #medicamentos
      x=x+1
    end
  end
=end

  def tiraZero(numero)
    i=0
    while (i<numero.length)
      if numero[i].eql?('0')
        numero[i]=''
        i += 1
      else
        break
      end
    end
    puts numero
    return numero

  end

  def referenciaMut(arr, reg)
    array2=[]
    p=0
    while p<arr.length
      array2 << arr[p].split(' ')
      p=p+1
    end
    p=0
    array = []
    while p<array2.length
      array.concat(array2[p])
      p=p+1
    end

    p=0
    num = ""
    gen_id = Genotipagem.last
    while p<array.length
      if /[^0-9]/.match(array[p]) && array[p].length == 1  #se for so uma letra
                                                           #mut = Mutacao.find_by_sigla(num + array[p])
        puts num+array[p]
        mut = Mutacao.all(:conditions=>"sigla = '"+tiraZero(num+array[p])+"' and regiao = '"+reg+"'")
      else
        #mut = Mutacao.find_by_sigla(array[p])
        puts array[p]
        mut = Mutacao.all(:conditions=>"sigla = '"+tiraZero(array[p])+"' and regiao = '"+reg+"'")
        num = array[p].gsub(/[^0-9]/, '')
      end
      gen_id.mutacaos<<mut
      p=p+1
    end

  end

  def referenciaMutErro(arr, reg)
    array2=[]
    p=0
    while p<arr.length
      array2 << arr[p].split(' ')
      p=p+1
    end
    p=0
    array = []
    while p<array2.length
      array.concat(array2[p])
      p=p+1
    end

    p=0
    num = ""
    gen_id = Genotipagemerro.last
    while p<array.length
      if /[^0-9]/.match(array[p]) && array[p].length == 1  #se for so uma letra
                                                           #mut = Mutacao.find_by_sigla(num + array[p])
        puts num+array[p]
        mut = Mutacaoerro.all(:conditions=>"sigla = '"+num+array[p]+"' and regiao = '"+reg+"'")
      else
        #mut = Mutacao.find_by_sigla(array[p])
        puts array[p]
        mut = Mutacaoerro.all(:conditions=>"sigla = '"+array[p]+"' and regiao = '"+reg+"'")
        num = array[p].gsub(/[^0-9]/, '')
      end
      puts mut
      gen_id.mutacaoerros<<mut
      p=p+1
    end

  end

  def principais(cell)
    possui = false
    @arr
    @arr2 = []
    if !cell[38].nil?
      @arr = cell[38].split('/')
      possui = true
    end

    i=0
    if possui==true
      while i<@arr.length
        @arr2 << @arr[i].split(' ')
        i=i+1
      end
      i=0
      @arr3 = []
      while i<@arr2.length
        @arr3.concat(@arr2[i])
        i=i+1
      end

      i=0
      num = ""

      while i<@arr3.length
        if /[^0-9]/.match(@arr3[i]) && @arr3[i].length == 1  #se for so uma letra
          Mutacao.create(sigla: tiraZero(num + @arr3[i]), regiao: 'Mutacoes principais')
        else
          Mutacao.create(sigla: tiraZero(@arr3[i]), regiao: 'Mutacoes principais')
          num = @arr3[i].gsub(/[^0-9]/, '')
        end
        i=i+1
      end
    end
  end

  def polimorfismos(cell)
    possui = false
    @arr
    @arr2 = []
    if !cell[39].nil?
      @arr = cell[39].split('/')
      possui = true
    end

    i=0
    if possui==true
      while i<@arr.length
        @arr2 << @arr[i].split(' ')
        i=i+1
      end
      i=0
      @arr3 = []
      while i<@arr2.length
        @arr3.concat(@arr2[i])
        i=i+1
      end

      i=0
      num = ""
      while i<@arr3.length
        if /[^0-9]/.match(@arr3[i]) && @arr3[i].length == 1  #se for so uma letra
                                                             #@arr4 << num + @arr3[i]
          Mutacao.create(sigla: tiraZero(num + @arr3[i]), regiao: 'Polimorfismos')
        else
          Mutacao.create(sigla: tiraZero(@arr3[i]), regiao: 'Polimorfismos')
          #@arr4 << @arr3[i]
          num = @arr3[i].gsub(/[^0-9]/, '')
        end
        i=i+1
      end
    end
  end

  def itrn(cell)
    possui = false
    @arr
    @arr2 = []
    if !cell[40].nil?
      @arr = cell[40].split('/')
      possui = true
    end

    i=0
    if possui==true
      while i<@arr.length
        @arr2 << @arr[i].split(' ')
        i=i+1
      end
      i=0
      @arr3 = []
      while i<@arr2.length
        @arr3.concat(@arr2[i])
        i=i+1
      end

      i=0
      num = ""

      while i<@arr3.length
        if /[^0-9]/.match(@arr3[i]) && @arr3[i].length == 1  #se for so uma letra
                                                             #@arr4 << num + @arr3[i]
          Mutacao.create(sigla: tiraZero(num + @arr3[i]), regiao: 'ITRN')
        else
          Mutacao.create(sigla: tiraZero(@arr3[i]), regiao: 'ITRN')
          #@arr4 << @arr3[i]
          num = @arr3[i].gsub(/[^0-9]/, '')
        end
        i=i+1
      end
    end
  end

  def itrnn(cell)
    possui = false
    @arr
    @arr2 = []
    if !cell[41].nil?
      @arr = cell[41].split('/')
      possui = true
    end

    i=0
    if possui==true
      while i<@arr.length
        @arr2 << @arr[i].split(' ')
        i=i+1
      end
      i=0
      @arr3 = []
      while i<@arr2.length
        @arr3.concat(@arr2[i])
        i=i+1
      end

      i=0
      num = ""

      while i<@arr3.length
        if /[^0-9]/.match(@arr3[i]) && @arr3[i].length == 1  #se for so uma letra
                                                             #@arr4 << num + @arr3[i]
          Mutacao.create(sigla: tiraZero(num + @arr3[i]), regiao: 'ITRNN')
        else
          Mutacao.create(sigla: tiraZero(@arr3[i]), regiao: 'ITRNN')
          #@arr4 << @arr3[i]
          num = @arr3[i].gsub(/[^0-9]/, '')
        end
        i=i+1
      end
    end
  end

  def polimorfismosTR(cell)
    possui = false
    @arr
    @arr2 = []
    if !cell[42].nil?
      @arr = cell[42].split('/')
      possui = true
    end

    i=0
    if possui==true
      while i<@arr.length
        @arr2 << @arr[i].split(' ')
        i=i+1
      end
      i=0
      @arr3 = []
      while i<@arr2.length
        @arr3.concat(@arr2[i])
        i=i+1
      end

      i=0
      num = ""

      while i<@arr3.length
        if /[^0-9]/.match(@arr3[i]) && @arr3[i].length == 1  #se for so uma letra
                                                             #@arr4 << num + @arr3[i]
          Mutacao.create(sigla: tiraZero(num + @arr3[i]), regiao: 'Polimorfismo na TR')
        else
          Mutacao.create(sigla: tiraZero(@arr3[i]), regiao: 'Polimorfismo na TR')
          #@arr4 << @arr3[i]
          num = @arr3[i].gsub(/[^0-9]/, '')
        end
        i=i+1
      end
    end
  end

  def principaisErro(cell)
    possui = false
    @arr
    @arr2 = []
    if !cell[38].nil?
      @arr = cell[38].split('/')
      possui = true
    end

    i=0
    if possui==true
      while i<@arr.length
        @arr2 << @arr[i].split(' ')
        i=i+1
      end
      i=0
      @arr3 = []
      while i<@arr2.length
        @arr3.concat(@arr2[i])
        i=i+1
      end

      i=0
      num = ""

      while i<@arr3.length
        if /[^0-9]/.match(@arr3[i]) && @arr3[i].length == 1  #se for so uma letra
          Mutacaoerro.create(sigla: num + @arr3[i], regiao: 'Mutacoes principais')
        else
          Mutacaoerro.create(sigla: @arr3[i], regiao: 'Mutacoes principais')
          num = @arr3[i].gsub(/[^0-9]/, '')
        end
        i=i+1
      end
    end
  end

  def polimorfismosErro(cell)
    possui = false
    @arr
    @arr2 = []
    if !cell[39].nil?
      @arr = cell[39].split('/')
      possui = true
    end

    i=0
    if possui==true
      while i<@arr.length
        @arr2 << @arr[i].split(' ')
        i=i+1
      end
      i=0
      @arr3 = []
      while i<@arr2.length
        @arr3.concat(@arr2[i])
        i=i+1
      end

      i=0
      num = ""
      while i<@arr3.length
        if /[^0-9]/.match(@arr3[i]) && @arr3[i].length == 1  #se for so uma letra
                                                             #@arr4 << num + @arr3[i]
          Mutacaoerro.create(sigla: num + @arr3[i], regiao: 'Polimorfismos')
        else
          Mutacaoerro.create(sigla: @arr3[i], regiao: 'Polimorfismos')
          #@arr4 << @arr3[i]
          num = @arr3[i].gsub(/[^0-9]/, '')
        end
        i=i+1
      end
    end
  end

  def itrnErro(cell)
    possui = false
    @arr
    @arr2 = []
    if !cell[40].nil?
      @arr = cell[40].split('/')
      possui = true
    end

    i=0
    if possui==true
      while i<@arr.length
        @arr2 << @arr[i].split(' ')
        i=i+1
      end
      i=0
      @arr3 = []
      while i<@arr2.length
        @arr3.concat(@arr2[i])
        i=i+1
      end

      i=0
      num = ""

      while i<@arr3.length
        if /[^0-9]/.match(@arr3[i]) && @arr3[i].length == 1  #se for so uma letra
                                                             #@arr4 << num + @arr3[i]
          Mutacaoerro.create(sigla: num + @arr3[i], regiao: 'ITRN')
        else
          Mutacaoerro.create(sigla: @arr3[i], regiao: 'ITRN')
          #@arr4 << @arr3[i]
          num = @arr3[i].gsub(/[^0-9]/, '')
        end
        i=i+1
      end
    end
  end

  def itrnnErro(cell)
    possui = false
    @arr
    @arr2 = []
    if !cell[41].nil?
      @arr = cell[41].split('/')
      possui = true
    end

    i=0
    if possui==true
      while i<@arr.length
        @arr2 << @arr[i].split(' ')
        i=i+1
      end
      i=0
      @arr3 = []
      while i<@arr2.length
        @arr3.concat(@arr2[i])
        i=i+1
      end

      i=0
      num = ""

      while i<@arr3.length
        if /[^0-9]/.match(@arr3[i]) && @arr3[i].length == 1  #se for so uma letra
                                                             #@arr4 << num + @arr3[i]
          Mutacaoerro.create(sigla: num + @arr3[i], regiao: 'ITRNN')
        else
          Mutacaoerro.create(sigla: @arr3[i], regiao: 'ITRNN')
          #@arr4 << @arr3[i]
          num = @arr3[i].gsub(/[^0-9]/, '')
        end
        i=i+1
      end
    end
  end

  def polimorfismosTRErro(cell)
    possui = false
    @arr
    @arr2 = []
    if !cell[42].nil?
      @arr = cell[42].split('/')
      possui = true
    end

    i=0
    if possui==true
      while i<@arr.length
        @arr2 << @arr[i].split(' ')
        i=i+1
      end
      i=0
      @arr3 = []
      while i<@arr2.length
        @arr3.concat(@arr2[i])
        i=i+1
      end

      i=0
      num = ""

      while i<@arr3.length
        if /[^0-9]/.match(@arr3[i]) && @arr3[i].length == 1  #se for so uma letra
                                                             #@arr4 << num + @arr3[i]
          Mutacaoerro.create(sigla: num + @arr3[i], regiao: 'Polimorfismo na TR')
        else
          Mutacaoerro.create(sigla: @arr3[i], regiao: 'Polimorfismo na TR')
          #@arr4 << @arr3[i]
          num = @arr3[i].gsub(/[^0-9]/, '')
        end
        i=i+1
      end
    end
  end

  def medicamentosErro(cell) #so tm erro por que os certos nao sao adicionados, e sim comparados com já existentes no bd
    cont = 0
    while(cont < 9)
      if(!cell[10 + cont*3].nil?)
        droga = cell[10 + cont*3].to_s.split('+')
        d = 0
        while(d < droga.length)
          if(!droga[d].eql?(''))
            Medicamentoerro.create(abreviacao: droga[d].strip)
            d=d+1
          end
        end
        cont = cont+1
      else
        break
      end
    end
  end

end