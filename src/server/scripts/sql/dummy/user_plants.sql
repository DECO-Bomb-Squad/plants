insert into users (id, username, email, bio, startDate, reputation) values (666, 'bombsquad', 'ted@kaczynski.com', 'You got mail!', '2022-05-30 18:30:53', 0);

insert into plant_types (id, type, commonName, fullName) values (101, 'Succulent', 'Aloe Vera', 'Aloe vera');
insert into plant_care_profile_default (plantTypeId, soilType, plantLocation, daysBetweenWatering, daysBetweenRepotting, daysBetweenFertilizer) values (101, 'mediumPot', 'fullSun', 37, 90, 90);
insert into plant_care_profile (id, soilType, plantLocation, daysBetweenWatering, daysBetweenRepotting, daysBetweenFertilizer) values (101, 'mediumPot', 'fullSun', 37, 90, 90);
insert into plants (id, plantName, plantDesc, plantTypeId, userId, careProfileId) values (101, 'Mittens', 'My sweet beautiful son', 101, 666, 101);
insert into activities (activityTime, activityTypeId, plantId) values ('2022-08-18', 1, 101);
insert into activities (activityTime, activityTypeId, plantId) values ('2022-08-30', 1, 101);
insert into photos (uri, photoTime, plantId) values ("https://www.almanac.com/sites/default/files/styles/large/public/image_nodes/aloe-vera-white-pot_sunwand24-ss_edit.jpg?itok=6dE5RWDP", "2022-08-20T15:30", 101);

insert into plant_types (id, type, commonName, fullName) values (102, 'Monstera', 'Common Monstera', 'Monstera deliciosa');
insert into plant_care_profile_default (plantTypeId, soilType, plantLocation, daysBetweenWatering, daysBetweenRepotting, daysBetweenFertilizer) values (102, 'mediumPot', 'fullShade', 7, 39, 60);
insert into plant_care_profile (id, soilType, plantLocation, daysBetweenWatering, daysBetweenRepotting, daysBetweenFertilizer) values (102, 'mediumPot', 'fullShade', 7, 39, 60);
insert into plants (id, plantName, plantDesc, plantTypeId, userId, careProfileId) values (102, 'Teddy', "", 102, 666, 102);
insert into activities (activityTime, activityTypeId, plantId) values ('2022-08-18', 1, 102);
insert into activities (activityTime, activityTypeId, plantId) values ('2022-08-30', 1, 102);
insert into photos (uri, photoTime, plantId) values ("https://www.thespruce.com/thmb/Yn-yjMFQGSvoH4_r3y-mLljqrjY=/4461x3346/smart/filters:no_upscale()/grow-monstera-adansonii-swiss-cheese-plant-1902774-hero-01-dc903dae459a4dd5b919d5e1d1bee9d3.jpg", "2022-08-20T15:30", 102);
insert into photos (uri, photoTime, plantId) values ("https://cdn.shopify.com/s/files/1/0416/6438/1085/products/monstera_900x.jpg?v=1659019393", "2022-08-18T14:15", 102);

insert into plant_types (id, type, commonName, fullName) values (103, 'Chili', "Bird's Eye Chili", 'Capsicum Annuum');
insert into plant_care_profile_default (plantTypeId, soilType, plantLocation, daysBetweenWatering, daysBetweenRepotting, daysBetweenFertilizer) values (103, 'mediumPot', 'partShade', 3, 40, 50);
insert into plant_care_profile (id, soilType, plantLocation, daysBetweenWatering, daysBetweenRepotting, daysBetweenFertilizer) values (103, 'mediumPot', 'partShade', 3, 40, 50);
insert into plants (id, plantName, plantDesc, plantTypeId, userId, careProfileId) values (103, 'Spicy', 'hot hot boi', 103, 666, 103);
insert into activities (activityTime, activityTypeId, plantId) values ('2022-08-18', 1, 103);
insert into activities (activityTime, activityTypeId, plantId) values ('2022-08-30', 1, 103);
insert into photos (uri, photoTime, plantId) values ("https://www.bolster.eu/media/images/1635_dbweb.jpg?1549350221", "2022-08-20T15:30", 103);

insert into plant_types (id, type, commonName, fullName) values (104, 'Pothos', "House Pothos", 'Epipremnum Aureum');
insert into plant_care_profile_default (plantTypeId, soilType, plantLocation, daysBetweenWatering, daysBetweenRepotting, daysBetweenFertilizer) values (104, 'fishTank', 'indoor', 10, 50, 70);
insert into plant_care_profile (id, soilType, plantLocation, daysBetweenWatering, daysBetweenRepotting, daysBetweenFertilizer) values (104, 'fishTank', 'indoor', 10, 50, 70);
insert into plants (id, plantName, plantDesc, plantTypeId, userId, careProfileId) values (104, 'Caspar', 'Needs special care', 104, 666, 104);
insert into activities (activityTime, activityTypeId, plantId) values ('2022-08-18', 1, 104);
insert into activities (activityTime, activityTypeId, plantId) values ('2022-08-30', 1, 104);
insert into photos (uri, photoTime, plantId) values ("https://cdn.shopify.com/s/files/1/0046/2467/9000/products/original_4ef6c2c8-df24-40a5-a410-92ade77f3504_2400x.jpg?v=1653960466", "2022-08-20T15:30", 104);