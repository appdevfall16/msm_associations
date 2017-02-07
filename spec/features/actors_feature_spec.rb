require "rails_helper"

RSpec.describe "Actors", type: :feature do

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

    it "displays each actor's name and dob", points: 5 do
      visit "/actors"

      actors = Actor.all
      actors.each do |actor|
        expect(page).to have_content(actor.name)
        expect(page).to have_content(actor.dob)
      end
    end

    it "displays a functional delete link for each actor", points: 5 do
      visit "/actors"

      count_of_actors = Actor.count

      click_link 'Delete', match: :first

      expect(Actor.count).to eq(count_of_actors - 1)
    end
  end

  context "show page" do
    # TODO
  end

  context "new form" do
    # TODO: test validation errors without correct inputs
    # Actor:
    #  - name: must be present; must be unique in combination with dob
    #  - dob: no rules
    #  - bio: no rules
    #  - image_url: no rules
  end

  context "edit form" do
    # TODO
  end
end
