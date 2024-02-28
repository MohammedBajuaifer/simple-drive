
# Simple Storage API Guide

Welcome to the Simple Storage API! This API allows you to store binary data using different storage options, including local storage, AWS S3, and directly in the database. Below you'll find how to interact with the API to create and retrieve blobs using various storage options.

## API Endpoints

### POST /api/blobs/
Use this endpoint to create a new blob with the data you want to store. You can specify where to store the data by setting the `storage_option` parameter to `"s3"`, `"local"`, or `"db"`.

#### Request Format

```http
POST http://127.0.0.1:3000/api/blobs/
Content-Type: application/json

{
        "data": "<base64_encoded_data>",
        "storage_option": "<storage_option>"
}
```

- `data`: Your file content, encoded in Base64 format.
- `storage_option`: Can be `"s3"`, `"local"`, or `"db"` to specify where to store the data.

#### Example

```http
POST http://127.0.0.1:3000/api/blobs/
Content-Type: application/json

{
        "data": "SGVsbG8gU2ltcGxlIFN0b3JhZ2UgV29ybGQh",
        "storage_option": "local"
}
```

### GET /api/blobs/{id}
Retrieve details about a blob stored outside the database (either in local storage or on AWS S3).

#### Request Format

```http
GET http://127.0.0.1:3000/api/blobs/{id}
```

- Replace `{id}` with the ID of the blob you wish to retrieve.

### GET /api/database_blobs/{id}
Retrieve details about a blob stored directly in the database. This endpoint is specifically for blobs saved with the `"db"` storage option.

#### Request Format

```http
GET http://127.0.0.1:3000/api/database_blobs/{id}
```

- Replace `{id}` with the ID of the blob you wish to retrieve.

## Usage Notes

- When storing data in `"s3"` or `"local"` storage, the API will save the decoded content of your Base64-encoded data and create a metadata record pointing to its location.
- For blobs stored with the `"db"` option, the data remains Base64-encoded in the database, and no external metadata is created.
- Use the appropriate GET request to retrieve your stored data. The `/api/blobs/{id}` endpoint is for blobs stored externally, while `/api/database_blobs/{id}` is for those stored in the database.

This API simplifies data storage by abstracting the complexities of dealing with different storage backends. Whether you're saving files locally, on S3, or directly in your database, Simple Storage API offers a unified interface to make these operations seamless.
