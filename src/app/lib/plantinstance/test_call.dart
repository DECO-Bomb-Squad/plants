String rawJson = '''[
  { 
    "id": 0,
    "name": "Teddy",
    "common_name": "Common Monstera",
    "scientific_name": "Monstera Deliciosa",
    "tags": [
        "Test tag"
    ],
    "watered": [
        "2022-07-14T21:52",
        "2022-08-28T23:28"
    ],
    "careProfile": {
      "daysBetweenFertilizer": 39,
      "daysBetweenWatering": 7,
      "daysBetweenRepotting": 60,
      "id": 66,
      "plantLocation": "fullShade",
      "soilType": "largePot"
    },
    "images": {
      "2022-08-20T15:30": "https://www.thespruce.com/thmb/Yn-yjMFQGSvoH4_r3y-mLljqrjY=/4461x3346/smart/filters:no_upscale()/grow-monstera-adansonii-swiss-cheese-plant-1902774-hero-01-dc903dae459a4dd5b919d5e1d1bee9d3.jpg",
      "2022-08-18T14:15": "https://cdn.shopify.com/s/files/1/0416/6438/1085/products/monstera_900x.jpg?v=1659019393"
    },
    "activities": [
        {
            "activityTypeId": 0,
            "id": 3,
            "plantId": 2,
            "time": "2022-08-29T15:30"
        },
        {
            "activityTypeId": 2,
            "id": 5,
            "plantId": 2,
            "time": "2022-08-29T15:30"
        },
        {
            "activityTypeId": 0,
            "id": 5,
            "plantId": 2,
            "time": "2022-08-25T15:30"
        },
        {
            "activityTypeId": 1,
            "id": 5,
            "plantId": 2,
            "time": "2022-08-20T15:30"
        },
        {
            "activityTypeId": 0,
            "id": 5,
            "plantId": 2,
            "time": "2022-08-20T15:30"
        }
    ],
    "user": {
        "userId": 1,
        "username": "Ted Kaczynski"
    }
  },
  { 
    "id": 1,
    "name": "Spicy",
    "common_name": "Bird's Eye Chili",
    "scientific_name": "Capsicum Annuum",
    "owner": "Dr Kaczynski",
    "tags": [
        "Test tag"
    ],
    "careProfile": {
      "daysBetweenFertilizer": 40,
      "daysBetweenWatering": 3,
      "daysBetweenRepotting": 50,
      "id": 77,
      "plantLocation": "partShade",
      "soilType": "mediumPot"
    },
    "images": {
      "2022-08-20T15:30": "https://www.bolster.eu/media/images/1635_dbweb.jpg?1549350221"
    },
    "activities": [
        {
            "activityTypeId": 0,
            "id": 3,
            "plantId": 2,
            "time": "2022-08-29T15:30"
        },
        {
            "activityTypeId": 2,
            "id": 5,
            "plantId": 2,
            "time": "2022-08-29T15:30"
        },
        {
            "activityTypeId": 0,
            "id": 5,
            "plantId": 2,
            "time": "2022-08-25T15:30"
        },
        {
            "activityTypeId": 1,
            "id": 5,
            "plantId": 2,
            "time": "2022-08-20T15:30"
        },
        {
            "activityTypeId": 0,
            "id": 5,
            "plantId": 2,
            "time": "2022-08-20T15:30"
        }
    ],
    "user": {
        "userId": 1,
        "username": "Ted Kaczynski"
    }
  },
  { 
    "id": 2,
    "name": "Greenie",
    "common_name": "House Pothos",
    "scientific_name": "Epipremnum Aureum",
    "tags": [
        "Test tag"
    ],
    "images": {
      "2022-08-20T15:30": "https://cdn.shopify.com/s/files/1/0046/2467/9000/products/original_4ef6c2c8-df24-40a5-a410-92ade77f3504_2400x.jpg?v=1653960466"
    },
    "careProfile": {
      "daysBetweenFertilizer": 50,
      "daysBetweenWatering": 10,
      "daysBetweenRepotting": 70,
      "id": 88,
      "plantLocation": "indoor",
      "soilType": "fishTank"
    },
    "activities": [
        {
            "activityTypeId": 0,
            "id": 3,
            "plantId": 2,
            "time": "2022-08-29T15:30"
        },
        {
            "activityTypeId": 2,
            "id": 5,
            "plantId": 2,
            "time": "2022-08-29T15:30"
        },
        {
            "activityTypeId": 0,
            "id": 5,
            "plantId": 2,
            "time": "2022-08-25T15:30"
        },
        {
            "activityTypeId": 1,
            "id": 5,
            "plantId": 2,
            "time": "2022-08-20T15:30"
        },
        {
            "activityTypeId": 0,
            "id": 5,
            "plantId": 2,
            "time": "2022-08-20T15:30"
        }
    ],
    "user": {
        "userId": 1,
        "username": "Ted Kaczynski"
    }
  },
  { 
    "id": 3,
    "name": "Jelly",
    "common_name": "Aloe",
    "scientific_name": "Aloe Vera",
    "tags": [
        "Test tag"
    ],
    "careProfile": {
      "daysBetweenFertilizer": 90,
      "daysBetweenWatering": 37,
      "daysBetweenRepotting": 90,
      "id": 99,
      "plantLocation": "partShade",
      "soilType": "largePot"
    },
    "images": {
      "2022-08-20T15:30": "https://www.almanac.com/sites/default/files/styles/large/public/image_nodes/aloe-vera-white-pot_sunwand24-ss_edit.jpg?itok=6dE5RWDP"
    },
    "activities": [
        {
            "activityTypeId": 0,
            "id": 3,
            "plantId": 2,
            "time": "2022-08-29T15:30"
        },
        {
            "activityTypeId": 2,
            "id": 5,
            "plantId": 2,
            "time": "2022-08-29T15:30"
        },
        {
            "activityTypeId": 0,
            "id": 5,
            "plantId": 2,
            "time": "2022-08-25T15:30"
        },
        {
            "activityTypeId": 1,
            "id": 5,
            "plantId": 2,
            "time": "2022-08-20T15:30"
        },
        {
            "activityTypeId": 0,
            "id": 5,
            "plantId": 2,
            "time": "2022-08-20T15:30"
        }
    ],
    "user": {
        "userId": 1,
        "username": "Ted Kaczynski"
    }
  }
]''';
