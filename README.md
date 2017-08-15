# TPS

Transform, Parse and Search.
... well not really transform, I just noticed that initech was in the test data and thought [I'd help Peter with his TPS reports](https://www.youtube.com/watch?v=jsLUidiYm0w)

TPS takes 3 json files, parses them ready to be searched. Those three files are:
- Organization json
- User json
- Ticket json

Each of the aforementioned input files are expected to be valid json, and an array of object. Once loaded you may list the searchable attributes or you may actually search them.

## Installation

### Dependencies
- ruby 2.4.1
- bundler
- yajl

### Getting Started

To get this running simply clone this repository to your machine and `bundle install`

```bash
git clone https://github.com/andrewbigger/tps.git
cd tps.git
bundle install
```

## Usage

Once installed, to run TPS, please execute:

```bash
bin/tps --orgs /path/to/organizations.json --users /path/to/users.json --tickets /path/to/tickets.json
```

And then follow the prompts.

You may exit at any time by entering the `quit` command at the current prompt

### Performance

JSON is parsed and loaded into memory, where the searching is done. For large files, parsing the JSON into memory objects takes the lion's share of the execution time.

### Search Behaviour

The default search matcher is a case insensitive match of any part of a string. However each record type is capable of implementing its own overrides for attributes where a partial match, or a string based match is not suitable.

For example, partial matching of IDs doesn't feel partiularly useful - i.e. searching for an ID of 1 using the default matcher will match any ID with 1 in it (1, 10, 11 etc).

Therefore, all ID attributes in known record types perform a case sensitive equivalence check before including them in the results.

Tag searches select from an array where a case insensitive partial match is observed on any one of the elements in the array. As such given the current implementation searching for multiple tags simultaneously isn't currently possible.

Boolean values are matched as strings. 

You may search for empty values by specifying `\empty` as your search term. Bad luck if you've got some data with backslash + empty.

## Tests and Quality Checks

To run application tests, please execute:

```bash
bundle exec rspec spec
```

Alternatively, RSpec tests are the default rake task so `bundle exec rake` is equivalent.

Included is a `.rubocop.yml` configuration file, however please note that rubocop is not included in the bundle. If you wish to run rubocop on this solution, please install it into your gemset, and then execute its binstub:

```bash
cd tps
gem install rubocop
rubocop
```
