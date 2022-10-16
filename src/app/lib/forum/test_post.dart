String rawJSON = '''{
  "comments": [
      {
          "content": "I am the one true original comment",
          "created": "2022-09-14T21:52",
          "id": 8,
          "score": 2,
          "parentId": null,
          "replies": [
              {
                  "content": "I am.a reply to the original comment! ",
                  "created": "2022-09-14T21:52",
                  "id": 10,
                  "parentId": 8,
                  "score": 3,
                  "replies": [],
                  "userId": 1
              }
          ],
          "userId": 2
      },
      {
          "content": "I am the second commenter!",
          "created": "2022-09-14T21:52",
          "id": 9,
          "score": 12,
          "parentId": null,
          "replies": [],
          "userId": 1
      }
  ],
  "content": "This is my first post, very impressive I know.",
  "created": "2022-09-14T21:52",
  "linkedPlants": [
      {
          "plantId": 1,
          "postId": 7
      },
      {
          "plantId": 3,
          "postId": 7
      }
  ],
  "postId": 7,
  "postTags": [
      {
          "id": 1,
          "postId": 7,
          "tagId": 2,
          "tagLabel": "European beaver"
      },
      {
          "id": 2,
          "postId": 7,
          "tagId": 3,
          "tagLabel": "Brown lemur"
      }
  ],
  "score": 0,
  "title": "My First Title",
  "userId": 1
}''';