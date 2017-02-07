require "rails_helper"

RSpec.describe "Directors", type: :feature do

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
    it "displays each director's name and dob", points: 5 do
      visit "/directors"

      directors = Director.all
      directors.each do |director|
        expect(page).to have_content(director.name)
        expect(page).to have_content(director.dob)
      end
    end

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

        expect(page).to have_content(director.movies.count)
      end
    end

    it "displays a list of the director's movies", points: 5 do
      directors = Director.all
      directors.each do |director|
        visit "/directors/#{director.id}"

        director.movies.each do |movie|
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

    it "creates a new movie after submitting the form", points: 10 do
      director = Director.last

      visit "/directors/#{director.id}"

      expect(page).to have_selector("form")

      count_of_movies = Movie.count

      fill_in 'Title', with: 'Mad Max: Fury Road'
      fill_in 'Year', with: 2015
      click_button 'Create Movie'

      expect(Movie.count).to eq(count_of_movies + 1)
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
    it 'creates a new director after submitting the form' do
      visit "/directors/new"

      expect(page).to have_selector("form")

      count_of_directors = Director.count

      fill_in 'Name', with: 'George Miller'
      fill_in 'Dob', with: 'March 3, 1945'
      click_button 'Create Director'

      new_count_of_directors = count_of_directors + 1
      expect(Director.count).to eq(new_count_of_directors)
    end

    it "doesn't save the record if the name is blank" do
      visit "/directors/new"

      expect(page).to have_selector("form")

      count_of_directors = Director.count

      fill_in 'Name', with: ''
      fill_in 'Dob', with: 'March 3, 1945'
      click_button 'Create Director'

      expect(Director.count).to eq(count_of_directors)
    end

    it "doesn't save the record if the name is not unique" do
      create(:director, name: "Alfred Hitchcock", dob: "August 13, 1899")

      visit "/directors/new"

      expect(page).to have_selector("form")

      count_of_directors = Director.count

      fill_in 'Name', with: 'Alfred Hitchcock'
      fill_in 'Dob', with: 'August 13, 1899'
      click_button 'Create Director'

      expect(Director.count).to eq(count_of_directors)
    end
  end

  context "edit form" do
    it "updates a director's data after submitting the form" do
      hitchcock = create(:director, name: "Alfred Hitchcock", dob: "August 13, 1899")
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
