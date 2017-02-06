class Location < ApplicationRecord
  # Constants
  ROOT = "root"
  COUNTRY = "country"
  STATE = "state"
  CITY = "city"
  NEIGHBORHOOD = "neighborhood"

  VALID_LEVELS = [
    ROOT,
    COUNTRY,
    STATE,
    CITY,
    NEIGHBORHOOD
  ]
  # country codes can be found here
  # https://www.iso.org/obp/ui/#search

  # Associations
  has_many :users
  
  # Extensions
  include Searchable
  extend FriendlyId
  friendly_id :name_and_short, :use => :slugged

  acts_as_tree order: "name"

  # Validations
  validates_presence_of :name, :slug
  validates_uniqueness_of :name, :scope => [:parent_id], :case_sensitive => false
  validates_uniqueness_of :slug, :scope => [:parent_id], :case_sensitive => false
  validates :level, :presence => true,
                            :inclusion => { :in => VALID_LEVELS, :message => "%{value} is not a valid level" }

  def should_generate_new_friendly_id?
    name_changed? || parent_id_changed? || short_changed?
  end

  def name_and_short
    return name if parent.nil?
    return "#{name}-#{parent.short}" if parent.short
    return "#{name}-#{parent}.name"
  end

  def self.create_root
    root = Location.find_or_create_by(name: 'Anywhere', level: Location::ROOT, parent_id: nil)
  end

  def self.import_countries
    self.create_root

    file_name = "countries.csv"
    csv_file = File.join("#{Rails.root}/db/seeds/", "#{file_name}")
    countries = CSV.read(csv_file)
    countries.each do |data|
      country = Location.find_or_create_by(name: data[0], short: data[1].upcase, level: Location::COUNTRY)
    end
  end

  def self.import_states
    self.import_countries

    file_name = "states.csv"
    csv_file = File.join("#{Rails.root}/db/seeds/", "#{file_name}")
    states = CSV.read(csv_file)
    states.each do |data|
      country_code = data[2].upcase
      country = Location.where(short: country_code, level: Location::COUNTRY).first

      state = Location.find_or_create_by(name: data[0], short: data[1].upcase, level: Location::STATE, parent_id: country.id)
    end
  end

  def self.import_cities
    self.import_states

    file_name = "cities.csv"
    csv_file = File.join("#{Rails.root}/db/seeds/", "#{file_name}")
    cities = CSV.read(csv_file)
    cities.each do |data|
      name = data[0]
      state_code = data[1]
      country_code = data[2]
      country = Location.where(short: country_code, level: Location::COUNTRY).first
      state = Location.where(short: state_code, level: Location::STATE, parent_id: country.id).first
      if country && state
        city = Location.find_or_create_by(name: name, level: Location::CITY, parent_id: state.id)
      end
    end
  end


end
