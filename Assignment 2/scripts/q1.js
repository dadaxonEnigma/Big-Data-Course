[
    {
        "$match": { "campaign_type": "bulk" }
    },
    {
        "$project": {
            "campaign_type": 1,
            "channel": 1,
            "total_count": 1,
            "purchases_made": 1,
            "purchase_rate": {
                "$cond": {
                    "if": { "$eq": ["$total_count", 0] },
                    "then": 0,
                    "else": { "$divide": ["$purchases_made", "$total_count"] }
                }
            }
        }
    },
    { "$sort": { "purchase_rate": -1 } },
    { "$limit": 100 }
]
