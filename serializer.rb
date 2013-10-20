RSpec.configure do |config|
  # Use color in STDOUT
  config.color_enabled = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :progress # :progress, :html, :textmate
end

#implement a song class and artist class to pass the specs below.
#serialize method should replace spaces in the song title with underscores
#and write to the current working directory

class Song

  attr_accessor :title, :artist

  def serialize
    File.open("#{self.title.downcase.gsub(' ','_')}.txt", "w+") do |f|
      f.write("#{self.artist.name} - #{self.title}")
    end
  end

  def self.deserialize(file_name)
    new_song = Song.new
    new_song.title = file_name.match(/^(.+)[.]/)[1].split('_').map {|w| w.capitalize}.join(' ')
    artist_name = ''
    File.open(file_name, "r").each_line do |line|
      artist_name = line.gsub!(" - #{new_song.title}", '')
    end
    new_song.artist = Artist.new(artist_name)

    new_song
  end
  
end

class Artist

  attr_reader :name

  def initialize(name)
    @name = name
  end
  
end

describe Song do
  it "has a title" do
    song = Song.new
    song.title = "Night Moves"
    song.title.should eq("Night Moves")
  end

  it "has an artist" do
    song = Song.new
    song.title = "Night Moves"
    song.artist = Artist.new("Bob Seger")
    song.artist.name.should eq("Bob Seger")
  end

  it "can save a representation of itself to a file" do
    song = Song.new
    song.title = "Night Moves"
    song.artist = Artist.new("Bob Seger")
    song.serialize
    File.read("night_moves.txt").should match /Bob Seger - Night Moves/
  end

  it "can rebuild a song from a file" do
    song = Song.deserialize("yellow_submarine.txt")
    song.title.should eq("Yellow Submarine")
    song.artist.name.should eq("The Beetles")
  end

end