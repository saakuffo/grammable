class GramsController < ApplicationController
  def index
  end

  def show    
  end

  def new
    @gram = Gram.create(gram_params)
  end

  def create
  end

  private

  def gram_params
    params.require(:gram).permit(:message)
  end
end
