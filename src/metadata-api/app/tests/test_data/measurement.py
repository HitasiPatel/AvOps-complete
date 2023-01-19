measurementPostValidPayloadData = {
    "id": "a57b24f2-9a91-4ebb-8805-679b7b8af7a5",
    "metadata": {
        "additionalProp1": "string",
        "additionalProp2": "string",
        "additionalProp3": "string",
    },
    "vehicle": {
        "id": "KA01LB1234",
        "name": "Duster",
        "platform": "SUV",
        "transmission": "MANUAL",
        "fuel": "PETROL",
        "make": "HYUNDAI",
        "model": "Seltos",
        "year": 2022,
        "isActive": True,
        "isDeleted": False,
        "metadata": {"height": "", "length": ""},
    },
    "driver": {
        "id": "john.doe",
        "firstName": "John",
        "lastName": "Doe",
        "email": "john.doe@gmail.com",
        "phone": "9999999999",
        "licenseNumber": "ABC123",
        "licenseFrontImageUrl": "https://blob/license_front_photo.jpg",
        "licenseBackImageUrl": "https://blob/license_back_photo.jpg",
        "driverPhotoUrl": "https://blob/photo.jpg",
        "address": "XYZ, Bangalore, Karnataka 560012",
        "location": {"type": "Point", "coordinates": [77.594566, 12.971599]},
        "isActive": True,
    },
    "createdAt": 1663916425,
    "description": "string",
    "task": {
        "id": "123e4567-e89b-12d3-a456-426614174000",
        "title": "task title",
        "description": "description of the task",
        "state": "UNASSIGNED",
        "conditions": [{"name": "area", "value": "Koramangala"}],
        "isActive": True,
        "isDeleted": False,
        "driverId": "john.vue",
        "vehicleId": "KA01LB1234",
        "startedAt": 1663916435,
        "completedAt": 1663916505,
        "status": "TODO",
        "metadata": {"height": "", "length": ""},
    },
    "files": [
        {
            "id": "123e4567-e89b-12d3-a456-426614174000",
            "filePath": "/ssd_a/<measurementId>/",
            "fileName": "Duster__2022-07-20-16-23-28_0.bag",
            "checksum": "abcd",
            "createdAt": 1698989898,
        }
    ],
}

measurementPostInValidPayloadMissingIdData = {
    "metadata": {
        "additionalProp1": "string",
        "additionalProp2": "string",
        "additionalProp3": "string",
    },
    "createdAt": 1663916425,
    "description": "string",
    "vehicle": {"id": "KA01LB1234"},
    "driver": {
        "id": "john.doe",
        "firstName": "John",
        "lastName": "Doe",
        "email": "john.doe@gmail.com",
        "phone": "9999999999",
        "licenseNumber": "ABC123",
    },
    "task": {
        "id": "123e4567-e89b-12d3-a456-426614174000",
        "title": "task title",
        "description": "description of the task",
        "state": "UNASSIGNED",
    },
    "files": [
        {
            "id": "123e4567-e89b-12d3-a456-426614174000",
            "filePath": "/ssd_a/<measurementId>/",
            "fileName": "Duster__2022-07-20-16-23-28_0.bag",
            "checksum": "abcd",
            "createdAt": 1698989898,
        }
    ],
}

measurementPostInValidPayloadMissingVehicleIdData = {
    "metadata": {
        "additionalProp1": "string",
        "additionalProp2": "string",
        "additionalProp3": "string",
    },
    "createdAt": 1663916425,
    "description": "string",
    "vehicle": {},
    "driver": {
        "id": "john.doe",
        "firstName": "John",
        "lastName": "Doe",
        "email": "john.doe@gmail.com",
        "phone": "9999999999",
        "licenseNumber": "ABC123",
    },
    "task": {
        "id": "123e4567-e89b-12d3-a456-426614174000",
        "title": "task title",
        "description": "description of the task",
        "state": "UNASSIGNED",
    },
    "files": [
        {
            "id": "123e4567-e89b-12d3-a456-426614174000",
            "filePath": "/ssd_a/<measurementId>/",
            "fileName": "Duster__2022-07-20-16-23-28_0.bag",
            "checksum": "abcd",
            "createdAt": 1698989898,
        }
    ],
}

measurementIdData = "ca087672-af62-4efc-9621-d913255c60d7"

measurementIdInvalidData = "a57b24f2-9a91-4ebb-8805-679b7b8af7a6"

measurementPostValidPayloadBaseData = {
    "id": "ca087672-af62-4efc-9621-d913255c60d7",
    "metadata": {
        "additionalProp1": "string",
        "additionalProp2": "string",
        "additionalProp3": "string",
    },
    "vehicle": {"id": "KA01LB1234"},
    "driver": {
        "id": "john.doe",
        "firstName": "John",
        "lastName": "Doe",
        "email": "john.doe@gmail.com",
        "phone": "9999999999",
        "licenseNumber": "ABC123",
    },
    "createdAt": 1663916425,
    "description": "string",
    "task": {
        "id": "123e4567-e89b-12d3-a456-426614174000",
        "title": "task title",
        "description": "description of the task",
        "state": "UNASSIGNED",
    },
    "files": [
        {
            "id": "123e4567-e89b-12d3-a456-426614174000",
            "filePath": "/ssd_a/<measurementId>/",
            "fileName": "Duster__2022-07-20-16-23-28_0.bag",
            "checksum": "abcd",
            "createdAt": 1698989898,
        }
    ],
}

measurementPatchValidPayloadData = {"tags": ["rainy"]}

measurementPatchInvalidPayloadData = {"createdAt": "00:00:00"}
