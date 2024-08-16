require 'spec_helper'
require_relative '../../src/database'

RSpec.describe Database, type: :model do

  after(:each) do
    db = Database.new('tests')
    db.drop
  end

  describe '#populate' do
    it 'true if table not exist' do
      db = Database.new('tests')
      db.query('DROP TABLE IF EXISTS tests')

      expect(db.populate_table('spec/support/test.csv')).to be true
      expect(db.query('SELECT * FROM tests').ntuples).to eq(3)
    end

    it 'false if table already exists' do
      db = Database.new('tests', 'spec/support/test.csv')

      expect(db.populate_table('spec/support/test.csv')).to be false
      expect(db.query('SELECT * FROM tests').ntuples).to eq(3)
    end
  end

  describe '#all' do
    it 'returns all information from the table' do
      db = Database.new('tests', 'spec/support/test.csv')

      result = db.all

      expect(result.size).to eq(3)
      expect(result[0].keys.size).to eq(17)
      expect(result[0]['id']).to eq('1')
      expect(result[1].keys.size).to eq(17)
      expect(result[1]['id']).to eq('2')
    end
  end

  describe '#find_by_token' do
    it 'returns a organized display with all infos within a token' do
      db = Database.new('tests', 'spec/support/test.csv')
      result = db.find_by_token('123456')

      expect(result.size).to eq(2)
      expect(result[0].keys.size).to eq(17)
      expect(result[0]['id']).to eq('1')
      expect(result[0]['result_token']).to eq('123456')
      expect(result[1].keys.size).to eq(17)
      expect(result[1]['id']).to eq('2')
      expect(result[1]['result_token']).to eq('123456')
    end
  end

  describe '#insert_table' do
    it 'inserts rows in the table' do
      db = Database.new('tests', 'spec/support/empty.csv')
      db.insert_table('spec/support/test.csv')

      expect(db.query('SELECT * FROM tests').ntuples).to eq(3)
    end
  end
end
