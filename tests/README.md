# Docker Autoheal Tests

Docker Compose is used to build and deploy test environment.

test.sh waits on watch-autoheal exit code.

Currently setup to a very basic exit 1 on invalid restart and exit 0 on valid restart. 

## Run tests
```
cd tests
./tests.sh
```

## Run tests in CI
```
cd tests
export "AUTOHEAL_CONTAINER_LABEL=autoheal-123456"
./tests.sh "MY_UNIQUE_BUILD_NUMBER_123456"
```

This enables the tests to only restart containers within the test spec by using
unique docker-compose project names and autoheal labels (as long as you replace
123456 by a unique number)
