require 'rails_helper'

RSpec.describe UserParticular, type: :model do
  # Seed the database before running any tests,
  # and roll back once all tests are finished
  before(:all) do
    ActiveRecord::Base.transaction do
      Rails.application.load_seed
      @seeded = true
    end
  end

  # Rollback transaction after each test case
  around(:each) do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end

  # Rollback the seeding after all tests are done
  after(:all) do
    if @seeded
      ActiveRecord::Base.connection.execute('DELETE FROM user_particulars')
    end
  end

  describe '.create' do
    it 'creates a new user particular' do
      attributes = {
        full_name: 'Ashin Jinarakkhita',
        phone_number: '03-21008141',
        secondary_phone_number: '03-21348711',
        country_of_origin: 'Myanmar',
        ethnicity: 'Chinese',
        religion: 'Buddhist',
        gender: 'Female',
        date_of_birth: Date.new(1999, 11, 1),
        date_of_arrival: Date.new(2019, 10, 20),
        photo_url: 'https://example.com/ashin_jinarakkhita_photo.jpg',
        birth_certificate_url: 'https://example.com/ashin_jinarakkhita_birth_certificate.jpg',
        passport_url: 'https://example.com/ashin_jinarakkhita_passport.jpg'
      }
      user_particular = UserParticular.create_user_particular(attributes)
      expect(user_particular).not_to be_nil
      expect(user_particular).to have_attributes(attributes)
    end
  end

  describe '.find_by_id' do
    it 'returns the user particular with the specified ID' do
      attributes = { 
        full_name: 'Rohingya Aung', 
        phone_number: '111-222-3333',
        secondary_phone_number: '555-555-5555',
        country_of_origin: 'Myanmar',
        ethnicity: 'Rohingya',
        religion: 'Muslim',
        gender: 'Male',
        date_of_birth: Date.new(1990, 3, 25),
        date_of_arrival: Date.new(2017, 9, 10),
        photo_url: 'https://example.com/rohingya_aung_photo.jpg',
        birth_certificate_url: 'https://example.com/rohingya_aung_birth_certificate.jpg',
        passport_url: 'https://example.com/rohingya_aung_passport.jpg'
      }
  
      # Find the first user particular to ensure it exists
      user_particular = UserParticular.first
      expect(user_particular).not_to be_nil
  
      # Test the find_by_id method
      found_user_particular = UserParticular.find_by_id(user_particular.id)
      expect(found_user_particular).not_to be_nil
      attributes.each do |key, value|
          expect(found_user_particular.send(key)).to eq(value)
      end
      
      #expect(found_user_particular.attributes.except('id', 'created_at', 'updated_at', 'date_of_birth', 'date_of_arrival').symbolize_keys).to eq(attributes)
    end  

    it 'returns nil if no user particular with the specified ID is found' do
      found_user_particular = UserParticular.find_by_id(999999) # Assuming there's no user particular with ID 999999
      expect(found_user_particular).to be_nil
    end
  end
end
