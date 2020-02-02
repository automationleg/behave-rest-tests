# Behave REST API tests

Repository contains a set of standard rest api steps(GET, POST, PUT, DELETE) to easily build behave test scenarios and validate api responses against specification ie: Swagger.
The example `smoke-rest-tests.feature` feature contains a demo working scenarios that can be tested as they are based on the [reqres.in](https://reqres.in) api service that provides a free simulation REST API interface for people who wants to try it
 Implementation covers the following:
  * Sending API request with or without payload to defined endpoint - GET, POST, PUT, DELETE
  * Validation of response code ie: 200, 401 etc.
  * Validation if response schema is correct - ie: required structure, fields and their types
  * Validation if certain fields in response are as expected

## Examples
All test examples can be executed by standard `behave` command executed from 
the project root folder. A few of those are listed below:
   ```gherkin
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
          "name": { "type": "string" },
          "job": { "type": "string" },
          "id": { "type": "string" },
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
                    "id": { "type": "integer" },
                    "email": { "type": "string" },
                    "first_name": { "type": "string" },
                    "last_name": { "type": "string" },
                    "avatar": { "type": "string" }
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
  ```

## How to install
1. copy `rest-steps` directory with all the content and place it into your `features` directory
2. add `from features.rest-steps import api_steps` import statement to you main steps file
   located usually in `features/steps/<yourfile_steps>.py` 
3. The following parameter is used in main request method: `Request is sent to "{uri}" URI`
* `context.api_url` - website url for example: `https://reqres.in`
Add that to your environment file
4. Add the following libraries to `requirement.txt` file
 ```
 requests == 2.19.1
 PyHamcrest==1.9.0
 jsonschema==3.2.0
 jsonpath_rw==1.4.0
 ```
 and install
 `pip install -r requirement.txt`
5. Start writing Gherkin scenarios with the new steps in feature files. 
     
 ## How to use it
 After installation is completed you can start creating test scenarios by using predefined behave steps.
 
 1. Validating request and response
 
 2. Schema validation
    To start validating a json response schema you need to create a schema first. 
    The easiest way to do it would be to use some online schema creation.  
    The handy one [Online json-to-schema-converter](https://www.liquid-technologies.com/online-json-to-schema-converter)
    can help you convert your example response into a required json schema  
    
    Once you have you schema - enter it as text together with the step:
    ```gherkin
    Then Json response is matching the schema
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
                    "id": { "type": "integer" },
                    "email": { "type": "string" },
                    "first_name": { "type": "string" },
                    "last_name": { "type": "string" },
                    "avatar": { "type": "string" }
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
    ```
    or store it as a string variable in a separate file under `json_schema_files` directory and user a json schema filename with it's schema attribute like below
    ```gherkin
    Then Json response is matching the "users_get" json schema from "reqres_schema" file
    ```
    The above step will validate against json schema defined in `reqres_schema.py` file with `users_get` attribute
    
 3. Validation of fields and their values
    The implementation was done with help of jsonpath and root element can be identified by the `$.` prefix ie:
    `"$.username"`
    For the reference on more complex searches have a look at [jsonpath vs xpath](https://goessner.net/articles/JsonPath/)
    web article that explains how to use jsonpath with reference to xpath
     