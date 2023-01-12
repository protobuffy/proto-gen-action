# Proto Gen Action 
An action to compile a github repo's protobufs to golang using `protoc`. 

# Usage

```
name: Proto Gen Demo
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Set output
        id: vars
        run: echo ::set-output name=branch_target::${GITHUB_REF#refs/*/}
      - name: Docker Step
        uses: protobuffy/proto-gen-action@v0.1.19
        with:
          origin: 'protobuf repo'
          destination: 'compiled code repo destination'
          branch-target: ${{ steps.vars.outputs.branch_target }}
          access-token: 'access-token for private github action.'
```

# License
The scripts and documentation in this project are released under the MIT License
