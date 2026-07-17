# Testing

This repository uses Amen for testing, along with the Belmont conformance test suite to ensure the Broadway provider adheres to the standard resource provider interface.

To run the test suite, execute the following command:

```bash
npx genie test
```

## Approach

The tests spin up a local HTTP mock server. The Broadway provider is then registered for HTTP and HTTPS protocols. Finally, the suite executes the standard Belmont conformance tests using a factory that defines how to instantiate existing, missing, creatable, and unsupported resources. This ensures that Broadway translates all standard provider operations correctly into HTTP requests and handles the corresponding responses properly.
