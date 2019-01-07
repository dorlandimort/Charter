require 'roo'
require 'fileutils'

class DatumService

  def self.save_file(datum, file)
    path = File.join('public', 'uploads', datum.id.to_s)
    FileUtils.mkdir_p path
    path = File.join(path, file.original_filename)
    File.open(path, 'wb') { |f| f.write(file.read) }
    path
  end

  def self.read_file_headers(datum, file)
    xlsx = Roo::Spreadsheet.open(file)

    sheet = xlsx.sheet(0)
    headers = []
    if sheet
      (sheet.first_column..sheet.last_column).each do |column|
        datum.headers.create!(name: sheet.cell(1, column).upcase)
      end
    end
  end

  def self.chart_data(datum)
    distritos = 0
    totals = {}
    xlsx = Roo::Spreadsheet.open(datum.file)
    sheet = xlsx.sheet(0)
    chart_data = {}
    if sheet
      total_rows = sheet.last_row - 1

      ((sheet.first_row + 1)..sheet.last_row).each do |row|
        cell = sheet.cell(row, datum.group_column)

        if cell != '' and not cell.nil?


          # create headers objects
          unless chart_data[cell]
            chart_data[cell] = {}
            distritos += 1
            totals[cell] = 0
          end

          datum.header_columns.each do |column|
            group_cell = sheet.cell(1, column.to_i)
            if chart_data[cell][group_cell].nil?
              chart_data[cell][group_cell] = { "total": 0 }
            end
            value_cell = sheet.cell(row, column.to_i)
            if value_cell == 'SI'
              chart_data[cell][group_cell][:total] += 1
              totals[cell] += 1
            end
          end


        end
      end
      # calculate %
      titles = []
      chart_data.each do |category, cat_value|
        cat_value.each do |group, group_value|
          percentage = (group_value[:total].to_f * 100.0 / totals[category].to_f).round(2)
          group_value[:percentage] = percentage
        end
        titles << category.delete(' ')
      end
      return {chart_data: chart_data, titles: titles}
    end
    return {}
  end

  def self.chart_data_reverse(datum)
    totals = {}
    xlsx = Roo::Spreadsheet.open(datum.file)
    sheet = xlsx.sheet(0)
    chart_data = {}
    if sheet

      datum.header_columns.each do |column|
        cell = sheet.cell(1, column.to_i)
        if cell != '' and not cell.nil?
          # create header objects
          unless chart_data[cell]
            chart_data[cell] = {}
            totals[cell] = 0
          end


          ((sheet.first_row + 1)..sheet.last_row).each do |row|
            group_cell = sheet.cell(row, datum.group_column)
            if chart_data[cell][group_cell].nil?
              chart_data[cell][group_cell] = { "total": 0 }
            end
            value_cell = sheet.cell(row, column.to_i)
            if value_cell == 'SI'
              chart_data[cell][group_cell][:total] += 1
              totals[cell] += 1
            end
          end

        end
      end
      # calculate %
      titles = []
      chart_data.each do |category, cat_value|
        cat_value.each do |group, group_value|
          percentage = (group_value[:total].to_f * 100.0 / totals[category].to_f).round(2)
          group_value[:percentage] = percentage
        end
        titles << category.delete(' ')
      end
      return {chart_data: chart_data, titles: titles}
    end
    return {}
  end
end