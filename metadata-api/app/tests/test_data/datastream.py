datastreamPostValidPayloadRawDataRaw = {
    "name": "MyDataStream",
    "type": "RAW",
    "lineage": {
        "producerMetadata": {
            "name": "adf-copy",
            "type": "measurement",
            "version": "001",
        },
        "sources": [],
    },
    "tags": [{"season":"rainy"}],
}

datastreamPostValidPayloadDataBad = {
    "name": "MyDataStream",
    "type": "RAWA",
    "lineage": {
        "producerMetadata": {
            "name": "adf-copy",
            "type": "measurement",
            "version": "001",
        },
        "sources": [],
    },
    "tags": [{"season":"rainy"}],
}

datastreamPostValidPayloadDataDerived = {
    "name": "MyDataStream",
    "type": "DERIVED",
    "lineage": {
        "producerMetadata": {
            "name": "adf-copy",
            "type": "measurement",
            "version": "001",
        },
        "sources": ["a57b24f2-9a91-4ebb-8805-679b7b8af7a6"],
    },
    "tags": [{"season":"rainy"}],
}

datastreamPostValidPayloadDataCurated = {
    "name": "MyDataStream",
    "type": "CURATED",
    "lineage": {
        "producerMetadata": {
            "name": "adf-copy",
            "type": "measurement",
            "version": "001",
        },
        "sources": ["a57b24f2-9a91-4ebb-8805-679b7b8af7a6"],
    },
    "tags": [{"season":"rainy"}],
}

datastreamPostValidPayloadDataAnnotated = {
    "name": "MyDataStream",
    "type": "ANNOTATED",
    "lineage": {
        "producerMetadata": {
            "name": "adf-copy",
            "type": "measurement",
            "version": "001",
        },
        "sources": [],
    },
    "tags":[{"season":"rainy"}],
}

datastreamPostValidPayloadDataAnnotatedWithSources = {
    "name": "MyDataStream",
    "type": "ANNOTATED",
    "lineage": {
        "producerMetadata": {
            "name": "adf-copy",
            "type": "measurement",
            "version": "001",
        },
        "sources": ["a57b24f2-9a91-4ebb-8805-679b7b8af7a6"],
    },
    "tags": [{"season":"rainy"}],
}

datastreamPostValidPayloadDataExtracted = {
    "name": "MyDataStream",
    "type": "EXTRACTED",
    "lineage": {
        "producerMetadata": {
            "name": "adf-copy",
            "type": "measurement",
            "version": "001",
        },
        "sources": ["a57b24f2-9a91-4ebb-8805-679b7b8af7a6"],
    },
    "tags": [{"season":"rainy"}],
}

datastreamPostValidPayloadDataSynchronized = {
    "name": "MyDataStream",
    "type": "SYNCHRONIZED",
    "lineage": {
        "producerMetadata": {
            "name": "adf-copy",
            "type": "measurement",
            "version": "001",
        },
        "sources": ["a57b24f2-9a91-4ebb-8805-679b7b8af7a6"],
    },
    "tags": [{"season":"rainy"}],
}

datastreamPostInValidPayloadMissingIdData = {
    "name": "MyDataStream",
    "lineage": {
        "producerMetadata": {
            "name": "adf-copy",
            "type": "measurement",
            "version": "001",
        },
        "sources": [],
    },
    "tags":[ ],
}

datastreamPostInValidPayloadRawDatastreamData = {
    "name": "MyDataStream",
    "type": "RAW",
    "lineage": {
        "producerMetadata": {
            "name": "adf-copy",
            "type": "measurement",
            "version": "001",
        },
        "sources": ["a57b24f2-9a91-4ebb-8805-679b7b8af7a8"],
    },
    "tags":[ ],
}

datastreamPostInValidPayloadDerivedDatastreamData = {
    "name": "MyDataStream",
    "type": "DERIVED",
    "lineage": {
        "producerMetadata": {
            "name": "adf-copy",
            "type": "measurement",
            "version": "001",
        },
        "sources": [""],
    },
    "tags":[ ],
}


datastreamPostInValidPayloadExtractedDatastreamData = {
    "name": "MyDataStream",
    "type": "EXTRACTED",
    "lineage": {
        "producerMetadata": {
            "name": "adf-copy",
            "type": "measurement",
            "version": "001",
        },
        "sources": [""],
    },
    "tags":[ ],
}

datastreamPostInValidPayloadCuratedDatastreamData = {
    "name": "MyDataStream",
    "type": "CURATED",
    "lineage": {
        "producerMetadata": {
            "name": "adf-copy",
            "type": "measurement",
            "version": "001",
        },
        "sources": [""],
    },
    "tags":[ ],
}

datastreamPostInValidPayloadAnnotatedDatastreamData = {
    "name": "MyDataStream",
    "type": "ANNOTATED",
    "lineage": {
        "producerMetadata": {
            "name": "adf-copy",
            "type": "measurement",
            "version": "001",
        },
        "sources": [""],
    },
    "tags":[ ],
}

datastreamPostInValidPayloadSynchronizedDatastreamData = {
    "name": "MyDataStream",
    "type": "SYNCHRONIZED",
    "lineage": {
        "producerMetadata": {
            "name": "adf-copy",
            "type": "measurement",
            "version": "001",
        },
        "sources": [""],
    },
    "tags":[ ],
}

datastreamPatchValidPayloadData = {"status": "CREATED", "tags": [{"season":"rainy"}]}

datastreamIdData = "a57b24f2-9a91-4ebb-8805-679b7b8af7a6"
