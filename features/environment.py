from behave import fixture, use_fixture


def before_all(context):
    context.api_url = 'https://reqres.in'

def before_feature(context, feature):
    pass