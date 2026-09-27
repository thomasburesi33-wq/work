{
    "TransitionDefaultMinimumObjectSize": "all_storage_classes_128K",
    "Rules": [
        {
            "Expiration": {
                "Days": 30
            },
            "ID": "expire-large-after-30-days",
            "Filter": {
                "Prefix": "large/"
            },
            "Status": "Enabled"
        },
        {
            "ID": "delete-noncurrent-versions",
            "Filter": {
                "Prefix": ""
            },
            "Status": "Enabled",
            "NoncurrentVersionExpiration": {
                "NoncurrentDays": 7
            }
        },
        {
            "ID": "abort-incomplete-multipart",
            "Filter": {
                "Prefix": ""
            },
            "Status": "Enabled",
            "AbortIncompleteMultipartUpload": {
                "DaysAfterInitiation": 7
            }
        }
    ]
}
