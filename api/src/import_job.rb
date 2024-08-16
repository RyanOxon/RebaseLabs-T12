require 'sidekiq'
require 'fileutils'
require_relative 'database'

class CsvImportJob
  include Sidekiq::Job

  def perform(file_path)
    db = Database.new('medical_records')
    db.insert_table(file_path)
    FileUtils.rm(file_path)
  end
end
