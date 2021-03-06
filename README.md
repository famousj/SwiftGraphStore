# Swift Graph Store

This is a library for reading from/writing to the Urbit GraphStore via the Swift airlock, UrsusHTTP.

This library only implements a subset of GraphStore, but is enough to setup a connection, read, write, and delete graphs.

## For Further Information

Graph Store docs can be found [here](https://urbit.org/docs/userspace/graph-store/overview).

[Also here](https://urbit.org/docs/userspace/landscape/reference/graph-store).

Although the most accurate up-to-date information is in `%landscape/app/graph-store.hoon`

Graph Store runs on gall.  Please peruse the [Gall Guide](https://github.com/timlucmiptev/gall-guide) for details about that.

## Contact

Best way to get a hold of me with questions is to DM me: `~ribben-donnyl`

## Things To Do

- Fill in `enum Contents` so it has all the possible values from `sur/post.hoon` (i.e. `mention`, `url`, `code`, `reference`)
- Make a `@da` (absolute date) type, which we can use to create date-based indices.  (Currently I just use Swift milliseconds since the epoch, but it'd be good to ahve an Urbit-native value)
- Handle more AFErrors for pokes/scries/subscriptions
- Make a `Term` type that validates that it's `actually-a-term`, and can convert to/from an `Atom`
- Signature
- Tags
- Archives
