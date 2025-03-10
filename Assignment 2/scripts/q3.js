[
    {
        "$match": {
            "$text": { "$search": "smartphone electronics" },
            "product_id": { "$in": [1004785, 1004786, 1004787] }
        }
    },
    {
        "$project": {
            "_id": 0,
            "product_id": 1,
            "product_name": 1,
            "category_code": 1,
            "brand": 1,
            "price": 1
        }
    }
]
