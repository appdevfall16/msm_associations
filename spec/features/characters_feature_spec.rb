require "rails_helper"

RSpec.describe "Characters", type: :feature do

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
    it "displays each character's name", points: 5 do
      visit "/characters"

      characters = Character.all
      characters.each do |character|
        expect(page).to have_content(character.name)
      end
    end

    it "displays each character's movie and actor", points: 10 do
      visit "/characters"

      characters = Character.all
      characters.each do |character|
        movie = Movie.find_by(id: character.movie_id)
        expect(page).to have_content(movie.title)

        actor = Actor.find_by(id: character.actor_id)
        expect(page).to have_content(actor.name)
      end
    end

    # TODO: Remove if not testing golden 7
    it "displays a functional delete link for each character", points: 5 do
      visit "/characters"

      count_of_characters = Character.count

      click_link 'Delete', match: :first

      expect(Character.count).to eq(count_of_characters - 1)
    end
  end

  context "show page" do
    it "displays the character's movie and actor", points: 10 do
      characters = Character.all
      characters.each do |character|
        visit "/characters/#{character.id}"

        movie = Movie.find_by(id: character.movie_id)
        expect(page).to have_content(movie.title)

        actor = Actor.find_by(id: character.actor_id)
        expect(page).to have_content(actor.name)
      end
    end
  end

  context "new form" do
    it "includes a dropdown with movies", points: 10 do
      visit "/characters/new"

      expect(page).to have_selector("select[name='movie_id']"), 'expected to find a select field for movie_id in the form'

      movies = Movie.all
      movies.each do |movie|
        expect(page).to have_selector("select[name='movie_id'] option[value='#{movie.id}']"),
          "expected to find options in the select field with value attributes for each movie's id"

        dropdown_option = find("select[name='movie_id'] option[value='#{movie.id}']").text
        expect(dropdown_option).to eq(movie.title),
          "expected to find options in the select field displaying each movie's title"
      end
    end

    it "includes a dropdown with actors", points: 10 do
      visit "/characters/new"

      expect(page).to have_selector("select[name='actor_id']"), 'expected to find a select field for actor_id in the form'

      actors = Actor.all
      actors.each do |actor|
        expect(page).to have_selector("select[name='actor_id'] option[value='#{actor.id}']"),
          "expected to find options in the select field with the value attributes for each actor's id"

        dropdown_option = find("select[name='actor_id'] option[value='#{actor.id}']").text
        expect(dropdown_option).to eq(actor.name),
          "expected to find options in the select field displaying each actor's name"
      end
    end

    it "displays a link to add a new movie", points: 2 do
      visit "/characters/new"

      expect(page).to have_link(nil, href: /movies\/new/)
    end

    it "displays a link to add a new actor", points: 2 do
      visit "/characters/new"

      expect(page).to have_link(nil, href: /actors\/new/)
    end

    # TODO: Remove if not testing golden 7
    it 'creates a new character after submitting the form', points: 5 do
      hardy = create(:new_actor, name: "Tom Hardy", dob: "September 15, 1977")

      visit "/characters/new"

      expect(page).to have_selector("form")

      count_of_characters = Character.count

      select 'Tom Hardy'
      select 'Inception'
      fill_in 'Name', with: 'Eames'
      click_button 'Create Character'

      new_count_of_characters = count_of_characters + 1
      expect(Character.count).to eq(new_count_of_characters)
    end

    it "doesn't save the record if the movie_id is nil", points: 2 do
      hardy = create(:new_actor, name: "Tom Hardy", dob: "September 15, 1977")

      visit "/characters/new"

      expect(page).to have_selector("form")

      count_of_characters = Character.count

      # TODO: how to select movie_id blank?
      select 'Tom Hardy'
      select ''
      fill_in 'Name', with: 'Eames'
      click_button 'Create Character'

      expect(Character.count).to eq(count_of_characters)
    end

    it "doesn't save the record if the actor_id is nil", points: 2 do
      hardy = create(:new_actor, name: "Tom Hardy", dob: "September 15, 1977")

      visit "/characters/new"

      expect(page).to have_selector("form")

      count_of_characters = Character.count

      # TODO: how to select actor_id blank?
      select ''
      select 'Inception'
      fill_in 'Name', with: 'Eames'
      click_button 'Create Character'

      expect(Character.count).to eq(count_of_characters)
    end
  end

  context "edit form" do
    it "includes a dropdown with movies", points: 10 do
      character = Character.last
      visit "/characters/#{character.id}/edit"

      within("select[name='movie_id']") do
        movies = Movie.all
        movies.each do |movie|
          expect(find("option[value='#{movie.id}']").text).to eq(movie.title),
            "expected to find option in the select field displaying each movie's title"
        end
      end
    end

    it "includes a dropdown with actors", points: 10 do
      character = Character.last
      visit "/characters/#{character.id}/edit"

      within("select[name='actor_id']") do
        actors = Actor.all
        actors.each do |actor|
          expect(find("option[value='#{actor.id}']").text).to eq(actor.name),
            "expected to find options in the select field displaying each actor's name"
        end
      end
    end
  end
end
