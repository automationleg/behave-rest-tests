Feature: Rest API basic confidence tests
  I order to be sure that my api is working
  I want to execute basic crud tests and validate:
    1. response codes
    2. response is matching the our json schema
    3. certain values in json response are as expected


@api
Scenario: Get user data
    Given Request is sent to "/api/users" URI
    Then Response is "200"
    And Json response is matching the schema
        """
        {
          "$schema": "http://json-schema.org/draft-04/schema#",
          "type": "object",
          "properties": {
            "page": { "type": "integer" },
            "per_page": { "type": "integer" },
            "total": { "type": "integer" },
            "total_pages": { "type": "integer" },
            "data": { "type": "array",
              "items": [
                {
                  "type": "object",
                  "properties": {
                    "id": {
                      "type": "integer"
                    },
                    "email": {
                      "type": "string"
                    },
                    "first_name": {
                      "type": "string"
                    },
                    "last_name": {
                      "type": "string"
                    },
                    "avatar": {
                      "type": "string"
                    }
                  },
                  "required": [
                    "id",
                    "email",
                    "first_name",
                    "last_name",
                    "avatar"
                  ]
                }
              ]
            }
          },
          "required": [
            "page",
            "per_page",
            "total",
            "total_pages",
            "data"
          ]
        }
        """


@api
Scenario: Get user data and validate against schema by schema name
    Given Request is sent to "/api/users" URI
    Then Response is "200"
    And Json response is matching the "users_get" schema


@api
Scenario: Create a User
    Given POST Request is sent to "/api/users" URI
      """
      {
        "name": "automationleg",
        "job": "testing"
      }
      """
    Then Response is "201"
    And Json response is matching the schema
      """
        {
        "$schema": "http://json-schema.org/draft-04/schema#",
        "type": "object",
        "properties": {
          "name": {
            "type": "string"
          },
          "job": {
            "type": "string"
          },
          "id": {
            "type": "string"
          },
          "createdAt": {
            "type": "string"
          }
        },
        "required": [
          "name",
          "job",
          "id",
          "createdAt"
        ]
      }
    """        
    And Field "$.name" in response json is equal to "automationleg"
    And Field "$.job" in response json is equal to "testing"  


@api
Scenario: Get single user data
    Given Request is sent to "/api/users/2" URI
    Then Response is "200"
    And Json response is matching the "single_user_get" schema
    And Field "$.data.email" in response json is equal to "janet.weaver@reqres.in"  