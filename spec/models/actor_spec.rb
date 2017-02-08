require 'rails_helper'

RSpec.describe Actor, type: :model do
  context 'validations' do
    it "will fail if the name is blank", points: 2 do
      actor = build(:actor, name: "Leonardo DiCaprio", dob: "November 11, 1974")
      expect(actor).to be_valid

      actor.name = ''
      expect(actor).to be_invalid
    end

    it "will fail if the name and dob combination isn't unique", points: 2 do
      actor1 = create(:actor, name: "Leonardo DiCaprio", dob: "November 11, 1974")
      actor2 = build(:actor, name: "Leo DiCaprio", dob: "November 11, 1974")
      expect(actor2).to be_valid

      actor2.name = actor1.name
      expect(actor2).to be_invalid
    end
  end

  it 'has many characters', points: 2 do
    scorsese = create(:director, name: "Martin Scorsese", dob: "November 17, 1942")
    departed = create(:movie, title: "The Departed", year: 2006, duration: 151, director_id: scorsese.id)
    actor = create(:actor, name: "Leonardo DiCaprio", dob: "November 11, 1974")
    billy = create(:character, name: 'Billy Costigan', movie_id: departed.id, actor_id: actor.id)

    expect(actor).to respond_to(:characters)
    expect(actor.characters).to include(billy)
  end

  it 'has many movies', points: 2 do
    scorsese = create(:director, name: "Martin Scorsese", dob: "November 17, 1942")
    departed = create(:movie, title: "The Departed", year: 2006, duration: 151, director_id: scorsese.id)
    actor = create(:actor, name: "Leonardo DiCaprio", dob: "November 11, 1974")
    billy = create(:character, name: 'Billy Costigan', movie_id: departed.id, actor_id: actor.id)

    expect(actor).to respond_to(:movies)
    expect(actor.movies).to include(departed)
  end
end
