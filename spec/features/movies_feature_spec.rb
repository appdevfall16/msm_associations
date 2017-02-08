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
    # TODO: Remove if not testing golden 7
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
        director = Director.find_by(id: movie.director_id)
        expect(page).to have_content(director.name)
      end
    end

    # TODO: Remove if not testing golden 7
    it "displays a functional delete link for each movie", points: 5 do
      visit "/movies"

      count_of_movies = Movie.count

      click_link 'Delete', match: :first

      expect(Movie.count).to eq(count_of_movies - 1)
    end
  end

  context "show page" do
    # TODO: Remove if not testing golden 7
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

        director = Director.find_by(id: movie.director_id)
        expect(page).to have_content(director.name)
      end
    end

    it "displays a count of the movie's characters", points: 5 do
      movies = Movie.all
      movies.each do |movie|
        visit "/movies/#{movie.id}"

        count_of_characters = Character.where(movie_id: movie.id).count
        expect(page).to have_content(count_of_characters)
      end
    end

    it "displays a list of the movie's actors (cast)", points: 5 do
      movies = Movie.all
      movies.each do |movie|
        visit "/movies/#{movie.id}"

        characters = Character.where(movie_id: movie.id)
        characters.each do |character|
          actor = Actor.find_by(id: character.actor_id)
          expect(page).to have_content(actor.name)
        end
      end
    end

    it "displays a form to add a new character", points: 2 do
      movies = Movie.all
      movies.each do |movie|
        visit "/movies/#{movie.id}"

        expect(page).to have_selector("form", count: 1)
      end
    end

    it "creates a new character for the movie after submitting the form", points: 10 do
      scorsese = Director.find_by(name: 'Martin Scorsese')
      wolf = create(:movie, title: "The Wolf of Wall Street", year: 2013, duration: 180, director_id: scorsese.id)

      visit "/movies/#{wolf.id}"

      expect(page).to have_selector("form")

      count_of_characters = Character.where(movie_id: wolf.id).count

      fill_in 'Name', with: 'Jordan Belfort'
      select 'Leonardo DiCaprio'
      click_button 'Create Character'

      expect(Character.where(movie_id: wolf.id).count).to eq(count_of_characters + 1)
    end

    it "displays a hidden input field to associate a new character to the movie", points: 10 do
      movies = Movie.all
      movies.each do |movie|
        visit "/movies/#{movie.id}"

        expect(page).to have_selector("input[value='#{movie.id}']", visible: false),
          "expected to find a hidden input field with the movie's id as the value"
      end
    end
  end

  context "new form" do
    it "includes a dropdown with directors", points: 10 do
      visit "/movies/new"

      expect(page).to have_selector("select[name='director_id']"), 'expected to find a select field for director_id in the form'

      directors = Director.all
      directors.each do |director|
        expect(page).to have_selector("select[name='director_id'] option[value='#{director.id}']"),
          "expected to find options in the select field with value attributes for each director's id"

        dropdown_option = find("select[name='director_id'] option[value='#{director.id}']").text
        expect(dropdown_option).to eq(director.name),
          "expected to find options in the select field displaying each director's name"
      end
    end

    it "displays a link to add a new director", points: 2 do
      visit "/movies/new"

      expect(page).to have_link(nil, href: /directors\/new/)
    end

    # TODO: Remove if not testing golden 7
    it 'creates a new movie after submitting the form', points: 5 do
      visit "/movies/new"

      expect(page).to have_selector("form")

      count_of_movies = Movie.count

      fill_in 'Title', with: 'Hugo'
      fill_in 'Year', with: 2011
      fill_in 'Duration', with: 126
      fill_in 'Description', with: 'In Paris in 1931, an orphan named Hugo Cabret who lives in the walls of a train station is wrapped up in a mystery involving his late father and an automaton.'
      select 'Martin Scorsese'
      click_button 'Create Movie'

      new_count_of_movies = count_of_movies + 1
      expect(Movie.count).to eq(new_count_of_movies)
    end

    it "doesn't save the record if the title is blank", points: 2 do
      visit "/movies/new"

      expect(page).to have_selector("form")

      count_of_movies = Movie.count

      fill_in 'Title', with: ''
      fill_in 'Year', with: 2011
      fill_in 'Duration', with: 126
      fill_in 'Description', with: 'In Paris in 1931, an orphan named Hugo Cabret who lives in the walls of a train station is wrapped up in a mystery involving his late father and an automaton.'
      select 'Martin Scorsese'
      click_button 'Create Movie'

      expect(Movie.count).to eq(count_of_movies)
    end

    it "doesn't save the record if the title and year aren't unique", points: 2 do
      scorsese = Director.find_by(name: 'Martin Scorsese')
      create(:movie, title: "The Wolf of Wall Street", year: 2013, duration: 180, director_id: scorsese.id)

      visit "/movies/new"

      expect(page).to have_selector("form")

      count_of_movies = Movie.count

      fill_in 'Title', with: 'The Wolf of Wall Street'
      fill_in 'Year', with: 2013
      fill_in 'Duration', with: 126
      fill_in 'Description', with: 'In Paris in 1931, an orphan named Hugo Cabret who lives in the walls of a train station is wrapped up in a mystery involving his late father and an automaton.'
      select 'Christopher Nolan'
      click_button 'Create Movie'

      expect(Movie.count).to eq(count_of_movies)
    end

    it "doesn't save the record if the director_id is blank", points: 2 do
      visit "/movies/new"

      expect(page).to have_selector("form")

      count_of_movies = Movie.count

      fill_in 'Title', with: 'Hugo'
      fill_in 'Year', with: 2011
      fill_in 'Duration', with: 126
      fill_in 'Description', with: 'In Paris in 1931, an orphan named Hugo Cabret who lives in the walls of a train station is wrapped up in a mystery involving his late father and an automaton.'
      # TODO: how to select is blank?
      select ''
      click_button 'Create Movie'

      expect(Movie.count).to eq(count_of_movies)
    end

    it "doesn't save the record if the year isn't between 1870 and 2050", points: 2 do
      visit "/movies/new"

      expect(page).to have_selector("form")

      count_of_movies = Movie.count

      fill_in 'Title', with: 'Hugo'
      fill_in 'Year', with: 2051
      fill_in 'Duration', with: 126
      fill_in 'Description', with: 'In Paris in 1931, an orphan named Hugo Cabret who lives in the walls of a train station is wrapped up in a mystery involving his late father and an automaton.'
      select 'Martin Scorsese'
      click_button 'Create Movie'

      expect(Movie.count).to eq(count_of_movies)
    end

    it "doesn't save the record if the duration isn't between 0 and 2764800", points: 2 do
      visit "/movies/new"

      expect(page).to have_selector("form")

      count_of_movies = Movie.count

      fill_in 'Title', with: 'Hugo'
      fill_in 'Year', with: 2011
      fill_in 'Duration', with: -1
      fill_in 'Description', with: 'In Paris in 1931, an orphan named Hugo Cabret who lives in the walls of a train station is wrapped up in a mystery involving his late father and an automaton.'
      select 'Martin Scorsese'
      click_button 'Create Movie'

      expect(Movie.count).to eq(count_of_movies)
    end
  end

  context "edit form" do
    it "includes a dropdown with directors", points: 10 do
      movie = Movie.last
      visit "/movies/#{movie.id}/edit"

      within("select[name='director_id']") do
        directors = Director.all
        directors.each do |director|
          expect(find("option[value='#{director.id}']").text).to eq(director.name),
            "expected to find options in the select field displaying each director's name"
        end
      end
    end
  end
end
