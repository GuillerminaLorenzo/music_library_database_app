require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  def reset_database_tables
    seed_sql = File.read('spec/seeds/albums_seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library' })
    connection.exec(seed_sql)
    seed_sql = File.read('spec/seeds/artists_seeds.sql')
    connection.exec(seed_sql)
  end
  
  before(:each) do
    reset_database_tables
  end
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  # context 'GET /albums' do
  #   it 'gets a list of all the albums' do
  #     response = get('/albums')

  #     expected_response = 'Doolittle, Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring'

  #     expect(response.status).to eq (200)
  #     expect(response.body).to eq (expected_response)
  #   end
  # end

  context 'POST /albums' do
    it 'creates a new album' do
      response = post(
        '/albums',
        title: 'Voyage',
        release_year: '2022',
        artist_id: '2'
      )

      expect(response.status).to eq 200
      expect(response.body).to eq ('')

      response = get('/albums')

      expect(response.body).to include('Voyage')
    end
  end

  # context 'GET /artists' do
  #   it 'gets a list of all the artists' do
  #     response = get('/artists')

  #     expected_response = ('Pixies, ABBA, Taylor Swift, Nina Simone')

  #     expect(response.status).to eq 200
  #     expect(response.body).to eq ('Pixies, ABBA, Taylor Swift, Nina Simone')
  #   end
  # end

  context 'POST /artists' do
    it 'creates a new artist' do 
      response = post(
        '/artists',
        name: 'Wild nothing',
        genre: 'Indie'
      )
    expect(response.status).to eq 200
    expect(response.body).to eq ('')
    
    response = get('/artists')

    expect(response.body).to include('Wild nothing')
    end
  end

  context 'GET /albums/:id' do
    it ' ' do
      response = get('/albums/2')

      expect(response.status).to eq 200
      expect(response.body).to include('<h1>Surfer Rosa</h1>')
    end
  end

  context 'GET /albums' do
    it '' do
      response = get('/albums')

      expect(response.status).to eq 200
      expect(response.body).to include('<a href="/albums/2"')
      expect(response.body).to include('Surfer Rosa')
      expect(response.body).to include('<div>')
    end
  end

  context "GET /artists/:id" do
    it "returns artists according to id" do
      response = get('/artists/2')

      expect(response.status).to eq 200
      expect(response.body).to include('ABBA')
      expect(response.body).to include('Pop')
    end
  end

  context 'GET /artists' do
    it 'returns a list of all artists' do
      response = get('/artists')

      expect(response.status).to eq 200
      expect(response.body).to include('ABBA')
      expect(response.body).to include('Taylor Swift')
      expect(response.body).to include('Pixies')
    end
  end

end