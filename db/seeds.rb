# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development? && AdminUser.where(email: 'admin@example.com').blank?

Institution.create!(name: 'YALE', code: 'YALE', zip_code: '06511') if Institution.of_code('YALE').blank?
Institution.create!(name: 'UPENN', code: 'UPENN', zip_code: '19104') if Institution.of_code('UPENN').blank?
Institution.create!(name: 'PRINCETON', code: 'PRINCETON', zip_code: '08544') if Institution.of_code('PRINCETON').blank?
Institution.create!(name: 'HARVARD', code: 'HARVARD', zip_code: '02138') if Institution.of_code('HARVARD').blank?
Institution.create!(name: 'DARTMOUTH', code: 'DARTMOUTH', zip_code: '03755') if Institution.of_code('DARTMOUTH').blank?
Institution.create!(name: 'MIT', code: 'MIT', zip_code: '02142') if Institution.of_code('MIT').blank?
Institution.create!(name: 'DUKE', code: 'DUKE', zip_code: '27708') if Institution.of_code('DUKE').blank?

ups_zones = [
              ['004', '005', '8'],
              ['010', '089', '8'],
              ['100', '199', '8'],
              ['200', '299', '8'],
              ['300', '339', '8'],
              ['341', '349', '8'],
              ['350', '358', '7'],
              ['359', '364', '8'],
              ['365', '367', '7'],
              ['368', '368', '8'],
              ['369', '372', '7'],
              ['373', '374', '8'],
              ['375', '375', '7'],
              ['376', '379', '8'],
              ['380', '384', '7'],
              ['385', '385', '8'],
              ['386', '397', '7'],
              ['398', '399', '8'],
              ['400', '418', '8'],
              ['420', '424', '7'],
              ['425', '459', '8'],
              ['460', '466', '7'],
              ['467', '468', '8'],
              ['469', '469', '7'],
              ['470', '473', '8'],
              ['474', '479', '7'],
              ['480', '497', '8'],
              ['498', '499', '7'],
              ['500', '504', '7'],
              ['505', '505', '6'],
              ['506', '507', '7'],
              ['508', '508', '6'],
              ['509', '509', '7'],
              ['510', '516', '6'],
              ['520', '560', '7'],
              ['561', '561', '6'],
              ['562', '567', '7'],
              ['570', '581', '6'],
              ['582', '582', '7'],
              ['583', '588', '6'],
              ['590', '591', '5'],
              ['592', '593', '6'],
              ['594', '594', '5'],
              ['595', '595', '6'],
              ['596', '599', '5'],
              ['600', '639', '7'],
              ['640', '649', '6'],
              ['650', '655', '7'],
              ['656', '676', '6'],
              ['677', '677', '5'],
              ['678', '678', '6'],
              ['679', '679', '5'],
              ['680', '692', '6'],
              ['693', '693', '5'],
              ['700', '709', '7'],
              ['710', '711', '6'],
              ['712', '717', '7'],
              ['718', '718', '6'],
              ['719', '725', '7'],
              ['726', '727', '6'],
              ['728', '728', '7'],
              ['729', '738', '6'],
              ['739', '739', '5'],
              ['740', '775', '6'],
              ['776', '777', '7'],
              ['778', '789', '6'],
              ['790', '791', '5'],
              ['792', '792', '6'],
              ['793', '794', '5'],
              ['795', '796', '6'],
              ['797', '799', '5'],
              ['800', '838', '5'],
              ['840', '853', '4'],
              ['854', '854', '3'],
              ['855', '863', '4'],
              ['864', '864', '3'],
              ['865', '865', '4'],
              ['870', '872', '5'],
              ['873', '874', '4'],
              ['875', '885', '5'],
              ['889', '892', '3'],
              ['893', '898', '4'],
              ['900', '935', '2'],
              ['936', '939', '3'],
              ['940', '942', '4'],
              ['943', '943', '3'],
              ['944', '949', '4'],
              ['950', '953', '3'],
              ['954', '961', '4'],
              ['970', '974', '5'],
              ['975', '976', '4'],
              ['977', '986', '5'],
              ['988', '994', '5']
]
ups_zones.each do |ups_zone|
  from_prefix, to_prefix, zone = ups_zone
  UpsZone.create!(from_prefix: from_prefix, to_prefix: to_prefix, zone: zone) if UpsZone.of_prefix(from_prefix, to_prefix).blank?
end

