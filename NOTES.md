
I used this to create the  table:

```
CREATE TABLE notes (
id UUID PRIMARY KEY,
created_on TIMESTAMP NOT NULL,
modfied_on TIMESTAMP,
title TEXT,
note TEXT
);
```

**Create table for schema**

```
CREATE TABLE api.notes (
id UUID PRIMARY KEY,
created_on TIMESTAMP NOT NULL,
modfied_on TIMESTAMP,
title TEXT,
note TEXT
);
```

**Copy table to file**

```
COPY notes TO '/Users/carlson/dev/racket/note/notes.csv';
```

**Copy table from file**

```
COPY api.notes FROM '/Users/carlson/dev/racket/note/notes.csv';
```

**Useful schema commmands**

- `grant select on api.notes to web_anon;`
- `create role notes_user nologin;`
- `grant notes_user to postgres;`
- `grant usage on schema api to notes_user;`
- `grant all on api.notes to notes_user;`


## Hmmm
- `grant usage, select on sequence api.todos_id_seq to todo_user`


## Queries

- `curl http://localhost:3000/notes?note=ilike.*why*`
- `curl http://localhost:3000/notes?title=037b75e1-ae57-49f1-8431-03b7c21f278c`

037b75e1-ae57-49f1-8431-03b7c21f278c
