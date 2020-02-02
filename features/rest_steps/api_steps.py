from behave import step
import requests as r
from jsonschema import validate
from hamcrest import *
import json
from features.rest_steps import json_schema_files
from jsonpath_rw import jsonpath, parse
from importlib import import_module


@step(u'Request is sent to "{uri}" URI')
def step_impl(context, uri):
    context.response = r.get(f'{context.api_url}{uri}')


@step('Response is "{http_code}"')
def step_impl(context, http_code):
    assert_that(context.response.status_code, equal_to(int(http_code)))


@step('Json response is matching the schema')
def step_impl(context):
    json_schema = json.loads(context.text)
    validate(context.response.json(), json_schema)


@step('Json response is matching the "{json_schema}" json schema from "{schema_file_name}" file')
def step_impl(context, json_schema, schema_file_name):
    json_schema_file = import_module(f'.{schema_file_name}', json_schema_files.__name__)
    loaded_schema = json.loads(getattr(json_schema_file, json_schema))
    validate(context.response.json(), loaded_schema)


@step('POST Request is sent to "{uri}" URI')
def step_impl(context, uri):
    payload = json.loads(context.text)
    context.response = r.post(f'{context.api_url}{uri}', data=payload)


@step('Field "{field_path}" in response json is equal to "{value}"')
def step_impl(context, field_path, value):
    print(context.response.json())
    jsonpath_expression = parse(field_path)
    match = jsonpath_expression.find(context.response.json())

    assert_that(match[0].value, equal_to(value))
    