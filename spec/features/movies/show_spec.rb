require 'rails_helper'

RSpec.describe 'movie show page' do
  before :each do 
    @user1 = User.create(name: "Asil Rolyat", email: "asil.rolyat@yourmom.com")
    @movie_id = 329

    @results_movies = File.read('spec/fixtures/movie_id_jurassic.json')
    stub_request(:get, "https://api.themoviedb.org/3/movie/#{@movie_id}?api_key=#{ENV['movie_api_key']}").
    to_return(status: 200, body: @results_movies)

    @results = File.read('spec/fixtures/jurassic_park_cast.json')
    stub_request(:get, "https://api.themoviedb.org/3/movie/329/credits?api_key=#{ENV['movie_api_key']}").
    to_return(status: 200, body: @results)
  end 

  it 'has a button to create a viewing party' do
    visit "users/#{@user1.id}/movies/#{@movie_id}"

    expect(page).to have_button("Create Viewing Party")

    click_button("Create Viewing Party")

    expect(current_path).to eq("/users/#{@user1.id}/movies/#{@movie_id}/parties/new")
  end

  it 'has a button to return to Discover page' do
    visit "users/#{@user1.id}/movies/#{@movie_id}"

    expect(page).to have_button("Discover Page")

    click_button("Discover Page")

    expect(current_path).to eq(user_discover_index_path(@user1))
  end

  it 'shows movie info from base movie endpoint' do 
    visit "users/#{@user1.id}/movies/#{@movie_id}"

    summary = "A wealthy entrepreneur secretly creates a theme park featuring living dinosaurs drawn from prehistoric DNA. Before opening day, he invites a team of experts and his two eager grandchildren to experience the park and help calm anxious investors. However, the park is anything but amusing as the security systems go off-line and the dinosaurs escape."
    genres = "Adventure Science Fiction"

    expect(page).to have_content("Jurassic Park")
    expect(page).to have_content(7.9)
    expect(page).to have_content("2hr 7min")
    expect(page).to have_content(summary)
    expect(page).to have_content(genres)
  end

  it 'shows cast info from movie cast endpoint' do 
    visit "users/#{@user1.id}/movies/#{@movie_id}"

    expect(page).to have_content("Jeff Goldblum as Dr. Ian Malcolm")
    expect(page).to have_content("Samuel L. Jackson as Arnold")
    expect(page).to_not have_content("Wayne Knight as Dennis Nedry") #womp womp
  end
end
