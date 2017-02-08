require 'rails_helper'

RSpec.describe Character, type: :model do
  context 'validations' do
    it "will fail if the movie_id is nil", points: 2 do
      scorsese = create(:director, name: "Martin Scorsese", dob: "November 17, 1942")
      departed = create(:movie, title: "The Departed", year: 2006, duration: 151, director_id: scorsese.id)
      leo = create(:actor, name: "Leonardo DiCaprio", dob: "November 11, 1974")
      character = build(:character, name: 'Billy Costigan', movie_id: departed.id, actor_id: leo.id)

      expect(character).to be_valid

      character.movie_id = nil
      expect(character).to be_invalid
    end

    it "will fail if the actor_id is nil", points: 2 do
      scorsese = create(:director, name: "Martin Scorsese", dob: "November 17, 1942")
      departed = create(:movie, title: "The Departed", year: 2006, duration: 151, director_id: scorsese.id)
      leo = create(:actor, name: "Leonardo DiCaprio", dob: "November 11, 1974")
      character = build(:character, name: 'Billy Costigan', movie_id: departed.id, actor_id: leo.id)

      expect(character).to be_valid

      character.actor_id = nil
      expect(character).to be_invalid
    end
  end

  it "belongs to a movie", points: 2 do
    scorsese = create(:director, name: "Martin Scorsese", dob: "November 17, 1942")
    departed = create(:movie, title: "The Departed", year: 2006, duration: 151, director_id: scorsese.id)
    leo = create(:actor, name: "Leonardo DiCaprio", dob: "November 11, 1974")
    character = create(:character, name: 'Billy Costigan', movie_id: departed.id, actor_id: leo.id)

    expect(character).to respond_to(:movie)
    expect(character.movie.title).to eq('The Departed')
  end

  it "belongs to an actor", points: 2 do
    scorsese = create(:director, name: "Martin Scorsese", dob: "November 17, 1942")
    departed = create(:movie, title: "The Departed", year: 2006, duration: 151, director_id: scorsese.id)
    leo = create(:actor, name: "Leonardo DiCaprio", dob: "November 11, 1974")
    character = create(:character, name: 'Billy Costigan', movie_id: departed.id, actor_id: leo.id)

    expect(character).to respond_to(:actor)
    expect(character.actor.name).to eq('Leonardo DiCaprio')
  end
end
