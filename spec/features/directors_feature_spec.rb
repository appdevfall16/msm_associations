require "rails_helper"

RSpec.describe "Directors", type: :feature do

  before do
    scorsese = create(:new_director, name: "Martin Scorsese", dob: "November 17, 1942")
    departed = create(:new_movie, title: "The Departed", year: 2006, duration: 151, director: scorsese)
    goodfellas = create(:new_movie, title: "Goodfellas", year: 1990, duration: 146, director: scorsese)

    nolan = create(:new_director, name: "Christopher Nolan", dob: "July 30, 1970")
    dark_knight = create(:new_movie, title: "The Dark Knight", year: 2008, duration: 152, director: nolan)
    inception = create(:new_movie, title: "Inception", year: 2010, duration: 148, director: nolan)

    leo = create(:new_actor, name: "Leonardo DiCaprio", dob: "November 11, 1974")
    create(:new_character, name: 'Cobb', movie: inception, actor: leo)
    create(:new_character, name: 'Billy Costigan', movie: departed, actor: leo)

    jack = create(:new_actor, name: "Jack Nicholson", dob: "April 22, 1937")
    create(:new_character, name: 'Frank Costello', movie: departed, actor: jack)

    bob = create(:new_actor, name: "Robert De Niro", dob: "August 17, 1943")
    create(:new_character, name: 'James Conway', movie: goodfellas, actor: bob)
  end

  context "index page" do
    # TODO: Remove if not testing golden 7
    it "displays each director's name and dob", points: 5 do
      visit "/directors"

      directors = Director.all
      directors.each do |director|
        expect(page).to have_content(director.name)
        expect(page).to have_content(director.dob)
      end
    end

    # TODO: Remove if not testing golden 7
    it "displays a functional delete link for each director", points: 5 do
      visit "/directors"

      count_of_directors = Director.count

      click_link 'Delete', match: :first

      expect(Director.count).to eq(count_of_directors - 1)
    end
  end

  context "show page" do
    it "displays a count of the director's movies", points: 5 do
      directors = Director.all
      directors.each do |director|
        visit "/directors/#{director.id}"

        count_of_movies = Movie.where(director_id: director.id).count

        expect(page).to have_content(count_of_movies)
      end
    end

    it "displays a list of the director's movies", points: 5 do
      directors = Director.all
      directors.each do |director|
        visit "/directors/#{director.id}"

        movies = Movie.where(director_id: director.id)
        movies.each do |movie|
          expect(page).to have_content(movie.title)
        end
      end
    end

    it "displays a form to add a new movie", points: 2 do
      directors = Director.all
      directors.each do |director|
        visit "/directors/#{director.id}"

        expect(page).to have_selector("form", count: 1)
      end
    end

    it "creates a new movie for the director after submitting the form", points: 10 do
      george_miller = create(:new_director, name: "George Miller", dob: "March 3, 1945")

      visit "/directors/#{george_miller.id}"

      expect(page).to have_selector("form")

      count_of_movies = Movie.where(director_id: george_miller.id).count

      fill_in 'Title', with: 'Mad Max: Fury Road'
      fill_in 'Year', with: 2015
      click_button 'Create Movie'

      expect(Movie.where(director_id: george_miller.id).count).to eq(count_of_movies + 1)
    end

    it "displays a hidden input field to associate a new movie to the director", points: 10 do
      directors = Director.all
      directors.each do |director|
        visit "/directors/#{director.id}"

        expect(page).to have_selector("input[value='#{director.id}']", visible: false),
          "expected to find a hidden input field with the director's id as the value"
      end
    end
  end

  context "new form" do
    # TODO: Remove if not testing golden 7
    it 'creates a new director after submitting the form', points: 5 do
      visit "/directors/new"

      expect(page).to have_selector("form")

      count_of_directors = Director.count

      fill_in 'Name', with: 'George Miller'
      fill_in 'Dob', with: 'March 3, 1945'
      click_button 'Create Director'

      new_count_of_directors = count_of_directors + 1
      expect(Director.count).to eq(new_count_of_directors)
    end

    it "doesn't save the record if the name is blank", points: 2 do
      visit "/directors/new"

      expect(page).to have_selector("form")

      count_of_directors = Director.count

      fill_in 'Name', with: ''
      fill_in 'Dob', with: 'March 3, 1945'
      click_button 'Create Director'

      expect(Director.count).to eq(count_of_directors)
    end

    it "doesn't save the record if the name isn't unique", points: 2 do
      create(:new_director, name: "Alfred Hitchcock", dob: "August 13, 1899")

      visit "/directors/new"

      expect(page).to have_selector("form")

      count_of_directors = Director.count

      fill_in 'Name', with: 'Alfred Hitchcock'
      fill_in 'Dob', with: 'March 3, 1945'
      click_button 'Create Director'

      expect(Director.count).to eq(count_of_directors)
    end
  end

  context "edit form" do
    # TODO: Remove if not testing golden 7
    it "updates a director's data after submitting the form", points: 5 do
      hitchcock = create(:new_director, name: "Alfred Hitchcock", dob: "August 13, 1899")
      expect(hitchcock.bio).to be_nil

      visit "/directors/#{hitchcock.id}/edit"

      bio = 'Sir Alfred Joseph Hitchcock was an English film director and producer, at times referred to as "The Master of Suspense".'
      fill_in 'Name', with: 'Sir Alfred Joseph Hitchcock'
      fill_in 'Bio', with: bio
      click_button 'Update Director'

      hitchcock.reload
      expect(hitchcock.name).to eq('Sir Alfred Joseph Hitchcock')
      expect(hitchcock.bio).to eq(bio)
    end
  end
end
