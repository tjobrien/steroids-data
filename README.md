# Steroids Data

Composable primitives for accessing cloud data in your steroids application.

## steroids.data.resource

The part that kinda looks like ActiveRecord. Allows you to declare a remote resource as a set of named actions relating to that resource.

## steroids.data.schema

The part that consumes data structures and spits out types. Allows you to build type validators based on descriptions from a remote source, eg. JSON-Schema.

## steroids.data.types

The part that looks like a bunch of type annotations. Provides validator functions that allow you to tell a type from another and use that information in a schema.

## steroids.data.cache

The part that goes around actions on a resource or ad-hoc use cases of it. Allows you to worry less about accessing the same data in multiple webviews or on multiple occasions.

## steroids.data.reactive

The part that drives your consumption of resources. Provides ready-made strategies for determining when the data is needed.