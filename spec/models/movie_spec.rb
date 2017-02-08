require 'rails_helper'

RSpec.describe Movie, type: :model do
  context 'validations' do
    it 'will fail if the director_id is nil', points: 2 do
      scorsese = create(:director, name: "Martin Scorsese", dob: "November 17, 1942")
      movie = build(:movie, title: "The Departed", year: 2006, duration: 151, director_id: scorsese.id)

      expect(movie).to be_valid

      movie.director_id = nil
      expect(movie).to be_invalid
    end

    it 'will fail if the title is blank', points: 2 do
      scorsese = create(:director, name: "Martin Scorsese", dob: "November 17, 1942")
      movie = build(:movie, title: "The Departed", year: 2006, duration: 151, director_id: scorsese.id)

      expect(movie).to be_valid

      movie.title = ''
      expect(movie).to be_invalid
    end

    it "will fail if the title and year combination isn't unique", points: 2 do
      scorsese = create(:director, name: "Martin Scorsese", dob: "November 17, 1942")
      movie1 = create(:movie, title: "The Departed", year: 2006, duration: 151, director_id: scorsese.id)
      movie2 = build(:movie, title: "Departed", year: 2006, duration: 151, director_id: scorsese.id)

      expect(movie2).to be_valid

      movie2.title = movie1.title
      expect(movie2).to be_invalid
    end

    it "will fail if the year isn't between 1870 and 2050", points: 2 do
      scorsese = create(:director, name: "Martin Scorsese", dob: "November 17, 1942")
      movie = build(:movie, title: "The Departed", year: 2006, duration: 151, director_id: scorsese.id)

      expect(movie).to be_valid

      movie.year = 2051
      expect(movie).to be_invalid
    end

    it "will fail if the duration isn't between 0 and 2764800", points: 2 do
      scorsese = create(:director, name: "Martin Scorsese", dob: "November 17, 1942")
      movie = build(:movie, title: "The Departed", year: 2006, duration: 151, director_id: scorsese.id)

      expect(movie).to be_valid

      movie.duration = -1
      expect(movie).to be_invalid
    end
  end

  it "belongs to a director", points: 2 do
    scorsese = create(:director, name: "Martin Scorsese", dob: "November 17, 1942")
    movie = create(:movie, title: "The Departed", year: 2006, duration: 151, director_id: scorsese.id)

    expect(movie).to respond_to(:director)
    expect(movie.director.name).to eq('Martin Scorsese')
  end

  it "has many characters", points: 2 do
    scorsese = create(:director, name: "Martin Scorsese", dob: "November 17, 1942")
    movie = create(:movie, title: "The Departed", year: 2006, duration: 151, director_id: scorsese.id)
    leo = create(:actor, name: "Leonardo DiCaprio", dob: "November 11, 1974")
    billy = create(:character, name: 'Billy Costigan', movie_id: movie.id, actor_id: leo.id)

    expect(movie).to respond_to(:characters)
    expect(movie.characters).to include(billy)
  end

  it "has many actors", points: 2 do
    scorsese = create(:director, name: "Martin Scorsese", dob: "November 17, 1942")
    movie = create(:movie, title: "The Departed", year: 2006, duration: 151, director_id: scorsese.id)
    leo = create(:actor, name: "Leonardo DiCaprio", dob: "November 11, 1974")
    billy = create(:character, name: 'Billy Costigan', movie_id: movie.id, actor_id: leo.id)

    expect(movie).to respond_to(:actors)
    expect(movie.actors).to include(leo)
  end
end
