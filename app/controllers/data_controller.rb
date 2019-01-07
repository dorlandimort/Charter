class DataController < ApplicationController

  before_action :load_datum, only: [:configure, :print, :chart_data]

  def new
    @datum = Datum.new
  end

  def create
    @datum = Datum.create(datum_params)
    @datum.file = DatumService.save_file(@datum, params[:datum][:file])
    @datum.save!
    DatumService.read_file_headers @datum, @datum.file
    redirect_to configure_datum_path(@datum)
  end

  def configure

  end

  def print
    @datum.group_column = params[:group_column]
    count_columns = params[:count_columns].delete('').split(',')
    @datum.header_columns = count_columns
    @datum.save!
    render layout: 'print'
  end

  def chart_data
    respond_to do |format|
      format.json {
        render json: @datum.reverse? ?  DatumService.chart_data_reverse(@datum) : DatumService.chart_data(@datum)
      }
    end
  end

  private

  def datum_params
    params.require(:datum).permit(:name, :columns, :rows, :group_column)
  end

  def load_datum
    @datum = Datum.find(params[:id])
  end
end
