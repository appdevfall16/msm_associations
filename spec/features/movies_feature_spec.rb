require "rails_helper"

RSpec.describe "Movies", type: :feature do

  before do
    scorsese = create(:director, name: "Martin Scorsese", dob: "November 17, 1942")
    departed = create(:movie, title: "The Departed", year: 2006, duration: 151, director: scorsese)
    goodfellas = create(:movie, title: "Goodfellas", year: 1990, duration: 146, director: scorsese)

    nolan = create(:director, name: "Christopher Nolan", dob: "July 30, 1970")
    dark_knight = create(:movie, title: "The Dark Knight", year: 2008, duration: 152, director: nolan)
    inception = create(:movie, title: "Inception", year: 2010, duration: 148, director: nolan)

    leo = create(:actor, name: "Leonardo DiCaprio", dob: "November 11, 1974")
    create(:character, name: 'Cobb', movie: inception, actor: leo)
    create(:character, name: 'Billy Costigan', movie: departed, actor: leo)

    jack = create(:actor, name: "Jack Nicholson", dob: "April 22, 1937")
    create(:character, name: 'Frank Costello', movie: departed, actor: jack)

    bob = create(:actor, name: "Robert De Niro", dob: "August 17, 1943")
    create(:character, name: 'James Conway', movie: goodfellas, actor: bob)
  end

  context "index page" do
    it "displays each movie's title and year", points: 5 do
      visit "/movies"

      movies = Movie.all
      movies.each do |movie|
        expect(page).to have_content(movie.title)
        expect(page).to have_content(movie.year)
      end
    end

    it "displays each movie's director", points: 10 do
      visit "/movies"

      movies = Movie.all
      movies.each do |movie|
        expect(page).to have_content(movie.director.name)
      end
    end

    it "displays a functional delete link for each movie", points: 5 do
      visit "/movies"

      count_of_movies = Movie.count

      click_link 'Delete', match: :first

      expect(Movie.count).to eq(count_of_movies - 1)
    end
  end

  context "show page" do
    it "displays the movie's title and year", points: 5 do
      movies = Movie.all
      movies.each do |movie|
        visit "/movies/#{movie.id}"

        expect(page).to have_content(movie.title)
        expect(page).to have_content(movie.year)
      end
    end

    it "displays the movie's director", points: 10 do
      movies = Movie.all
      movies.each do |movie|
        visit "/movies/#{movie.id}"

        expect(page).to have_content(movie.director.name)
      end
    end
  end

  context "new form" do
    # TODO: test validation errors without correct inputs
    # Movie:
    #  - director_id: must be present
    #  - title: must be present; must be unique in combination with year
    #  - year: must be integer between 1870 and 2050
    #  - duration: must be integer between 0 and 2764800
    #  - description: no rules
    #  - image_url: no rules

    it "includes a dropdown with directors", points: 10 do
      visit "/movies/new"

      directors = Director.all
      directors.each do |director|
        expect(page).to have_selector("select[name='director_id']"), 'expected to find a select field for director_id in the form'
        expect(page).to have_selector("select[name='director_id'] option[value='#{director.id}']"),
          "expected to find a director option in the select field with a value using the director's id"

        dropdown_option = find("select[name='director_id'] option[value='#{director.id}']").text
        expect(dropdown_option).to eq(director.name),
          "expected to find a director option in the select field displaying the director's name"
      end

      # TODO: test submit works and saves movie with director
    end

    it "displays a link to add a new director", points: 2 do
      visit "/movies/new"

      expect(page).to have_link(nil, href: /directors\/new/)
    end
  end

  context "edit form" do
    it "includes a dropdown with directors", points: 10 do
      movie = Movie.last
      visit "/movies/#{movie.id}/edit"

      within("select[name='director_id']") do
        directors = Director.all
        directors.each do |director|
          expect(find("option[value='#{director.id}']").text).to eq(director.name)
        end
      end
    end
  end
end
