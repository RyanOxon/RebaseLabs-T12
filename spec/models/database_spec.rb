require 'spec_helper'
require_relative '../../src/models/database'

RSpec.describe Database, type: :model do
  before(:each) do
    @db = Database.new('tests', 'spec/support/test.csv')
  end

  after(:each) do
    @db.query('DROP TABLE IF EXISTS tests')
  end

  describe '#populate' do
    it 'a empty table' do
      @db.query('DROP TABLE IF EXISTS tests')

      expect(@db.populate_table('spec/support/test.csv')).to be true
      expect(@db.query('SELECT * FROM tests').ntuples).to eq(2)
    end

    it 'only if table does not exist' do
      expect(@db.populate_table('spec/support/test.csv')).to be false
      expect(@db.query('SELECT * FROM tests').ntuples).to eq(2)
    end
  end

  describe '#all' do
    it 'successfully' do
      result = @db.all

      expect(result.size).to eq(2)
      expect(result[0].keys.size).to eq(17)
      expect(result[0]['id']).to eq('1')
      expect(result[1].keys.size).to eq(17)
      expect(result[1]['id']).to eq('2')
    end
  end
end
