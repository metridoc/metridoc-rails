# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password', super_admin: true) if Rails.env.development? && AdminUser.where(email: 'admin@example.com').blank?

Institution.create!(name: 'YALE', code: 'YALE', zip_code: '06511') if Institution.of_code('YALE').blank?
Institution.create!(name: 'UPENN', code: 'UPENN', zip_code: '19104') if Institution.of_code('UPENN').blank?
Institution.create!(name: 'PRINCETON', code: 'PRINCETON', zip_code: '08544') if Institution.of_code('PRINCETON').blank?
Institution.create!(name: 'HARVARD', code: 'HARVARD', zip_code: '02138') if Institution.of_code('HARVARD').blank?
Institution.create!(name: 'DARTMOUTH', code: 'DARTMOUTH', zip_code: '03755') if Institution.of_code('DARTMOUTH').blank?
Institution.create!(name: 'MIT', code: 'MIT', zip_code: '02142') if Institution.of_code('MIT').blank?
Institution.create!(name: 'DUKE', code: 'DUKE', zip_code: '27708') if Institution.of_code('DUKE').blank?
Institution.create!(name: 'UCHICAGO', code: 'UCHICAGO', zip_code: '60637') if Institution.of_code('UCHICAGO').blank?
Institution.create!(name: 'STANFORD', code: 'STANFORD', zip_code: '94305') if Institution.of_code('STANFORD').blank?
Institution.create!(name: 'BROWN', code: 'BROWN', zip_code: '02912') if Institution.of_code('BROWN').blank?
Institution.create!(name: 'JHU', code: 'JHU', zip_code: '21218') if Institution.of_code('JHU').blank?
Institution.create!(name: 'CORNELL', code: 'CORNELL', zip_code: '14853') if Institution.of_code('CORNELL').blank?
Institution.create!(name: 'COLUMBIA', code: 'COLUMBIA', zip_code: '10027') if Institution.of_code('COLUMBIA').blank?
