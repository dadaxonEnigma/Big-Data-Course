[
    {
        "$match": {
            "event_type": "view"
        }
    },
    {
        "$group": {
            "_id": {
                "user_id": "$user_id",
                "category_code": "$category_code",
                "brand": "$brand"
            },
            "view_count": {
                "$sum": 1
            }
        }
    },
    {
        "$sort": {
            "view_count": -1
        }
    },
    {
        "$limit": 10
    }
]
