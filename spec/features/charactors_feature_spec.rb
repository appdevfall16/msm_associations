require "rails_helper"

RSpec.describe "Characters", type: :feature do

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
    # TODO

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
        expect(page).to have_content(character.actor.name)
        expect(page).to have_content(character.movie.title)
      end
    end

    it "displays a functional delete link for each character", points: 5 do
      visit "/characters"

      count_of_characters = Character.count

      click_link 'Delete', match: :first

      expect(Character.count).to eq(count_of_characters - 1)
    end
  end

  context "show page" do
    # TODO
  end

  context "new form" do
    # TODO: test validation errors without correct inputs
    # Character:
    #  - movie_id: must be present
    #  - actor_id: must be present
    #  - name: no rules
  end

  context "edit form" do
    # TODO
  end
end
