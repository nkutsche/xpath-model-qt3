# XPath XML Model

This project is just for testing the basic project [xpath-model](https://github.com/nkutsche/xpath-model) against the [QT3 testsuite](https://github.com/w3c/qt3tests) using the [test driver of BaseX](https://github.com/BaseXdb/basex/tree/master/basex-tests). 

*Note:* as the basex-tests are not available on Maven Central I added the testdriver classes as a copy into this project. [Copyright of this classes is on BaseX](src/main/java/org/basex/tests/LICENSE.txt).

## Testing scenario

For testing the XPath Model project this project does the following:

1. parses any XPath expression in the QT3TS which does not contain any static error to the model. **Note:** it ignores any XQuery expressions.
1. Validates the result against the model schema.
1. If not valid: it throws an error.
1. If valid: re-serialize the model to XPath expressions.
1. Executes the original expression and the re-serialized expressions in the provided context and checks that the result is the same.
