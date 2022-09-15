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


  context 'POST /albums' do
    it 'should validate album parameters' do
      response = post('/albums', invalid_album_title: 'Voyage', another_invalid_thing: 123)

      expect(response.status).to eq 400
    end

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

  context 'POST /artists' do
    it 'should validate artist parameters' do
      response = post('/artists', invalid_artist_title: 'Wild nothing', another_invalid_thing: 123)

      expect(response.status).to eq 400
    end

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

  context 'GET /albums' do
    it '' do
      response = get('/albums')

      expect(response.status).to eq 200
      expect(response.body).to include('<a href="/albums/2"')
      expect(response.body).to include('Surfer Rosa')
      expect(response.body).to include('<div>')
    end
  end

  context 'GET /albums/new' do
    it 'form to add a new album' do
      response = get('/albums/new')

      expect(response.status).to eq 200
      expect(response.body).to include('<form method="POST" action="/albums">')
      expect(response.body).to include('<input type="text" name="title" />')
      expect(response.body).to include('<input type="text" name="release_year" />')
      expect(response.body).to include('<input type="text" name="artist_id" />')
    end
  end

  context 'GET /albums/:id' do
    it ' ' do
      response = get('/albums/2')

      expect(response.status).to eq 200
      expect(response.body).to include('<h1>Surfer Rosa</h1>')
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

  context 'GET /artists/new' do
    it 'form to add a new artist' do
      response = get('/artists/new')

      expect(response.status).to eq 200
      expect(response.body).to include('<form method="POST" action="/artists">')
      expect(response.body).to include('<input type="text" name="name" />')
      expect(response.body).to include('<input type="text" name="genre" />')
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
end