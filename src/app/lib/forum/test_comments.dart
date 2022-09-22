String rawJSON = '''
  {
    "comment_id": 1,
    "author_id": 1,
    "score": 21,
    "content": "This is an example comment",
    "created":  "2012-07-14T21:52",
    "replies": [
      {
        "comment_id": 2,
        "author_id": 2,
        "score": 1,
        "content": "Damn that's crazy",
        "created":  "2022-07-14T21:52",
      },
      {
        "comment_id": 4,
        "author_id": 1,
        "score": 13,
        "content": "Shut up",
        "created":  "2022-09-14T21:52",
      }
    ]
  },
  {
    "comment_id": 3,
    "author_id": 3,
    "score": 1,
    "content": "Example longer comment. Fugit aperiam harum ut est dolores sunt ut. Neque et labore consectetur hic tenetur et. Corporis et facere quam maxime voluptas. Sunt nihil ut veritatis et. Autem porro laudantium at dolor sequi asperiores nobis sed. Unde eos deserunt quas nesciunt vitae.",
    "created":  "2012-07-14T21:52",
    "replies": [
  }
''';