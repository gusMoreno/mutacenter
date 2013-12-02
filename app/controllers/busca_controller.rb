class BuscaController < ApplicationController
  def busca
    @drogas = params[:drogas]

  end
end
