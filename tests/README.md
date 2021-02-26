# Docker Autoheal Tests

Docker Compose is used to build and deploy test environment.

test.sh waits on watch-autoheal exit code.

Currently setup to a very basic exit 1 on invalid restart and exit 0 on valid restart. 

## Run tests
```
cd tests
./tests.sh
```
