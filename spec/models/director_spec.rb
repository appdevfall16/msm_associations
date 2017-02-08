require 'rails_helper'

RSpec.describe Director, type: :model do
  context 'validations' do
    it "will fail if the name is blank", points: 2 do
      director = build(:director, name: "Alfred Hitchcock", dob: "August 13, 1899")
      expect(director).to be_valid

      director.name = ''
      expect(director).to be_invalid
    end

    it "will fail if the name and dob combination isn't unique", points: 2 do
      director1 = create(:director, name: "Alfred Hitchcock", dob: "August 13, 1899")
      director2 = build(:director, name: "Sir Alfred Joseph Hitchcock", dob: "August 13, 1899")
      expect(director2).to be_valid

      director2.name = director1.name
      expect(director2).to be_invalid
    end
  end

  it "has many movies", points: 2 do
    director = create(:director, name: "Martin Scorsese", dob: "November 17, 1942")
    departed = create(:movie, title: "The Departed", year: 2006, duration: 151, director_id: director.id)
    goodfellas = create(:movie, title: "Goodfellas", year: 1990, duration: 146, director_id: director.id)

    expect(director).to respond_to(:movies)
    expect(director.movies).to include(departed, goodfellas)
  end
end
