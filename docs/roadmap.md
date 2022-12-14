# Roadmap πΊοΈ

As this package is highly experimental and new, a high-level overview of the roadmap can be useful. It will allow people to more easily track what features Wattle(s) is getting and what their states are.

## Areas of Focus π‘

### Production Readiness βοΈ

#### Testing π§ͺ

- [ ] 100% test coverage for all packages

#### Documentation ποΈ

- [ ] Comprehensive Documentation for getting started with Wattle(s)
  - [x] Creating a `Struct`
  - [x] Creating a `Schema`
  - [ ] Create a `DataSource`
  - [ ] Showcase by getting a `DataStore` for the struct
- [ ] Document how to write a driver implementation
- [ ] Documentation Site

### Features β¨

- [x] Map a schema to a table.
- [ ] Validating data, both incoming and outgoing
- [ ] Support relations
  - [ ] One to one
  - [ ] Many to one
  - [ ] One to many
  - [ ] Many to Many
- [ ] Make the query builder more versatile yet stricter
  - `WhereBuilder` operator methods should return a `WhereResult` that only has an `and` method
  - Support the at least the following WHERE operators
    - [ ] Equals and not equals (`=`, `!=`)
    - [ ] Greater than and it's equals variant (`>`, `>=`)
    - [ ] Less than and it's equal variant (`<`, `<=`)
- [ ] Add a way to stream query results: `streamQuery`
- [x] Support in-memory driver
- [ ] Support SQL based driver
- [ ] Support Redis driver