
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
- `create role todo_user nologin;`
- `grant todo_user to postgres;`
- `grant usage on schema api to todo_user;`
- `grant all on api.todos to todo_user;`
- `grant usage, select on sequence api.todos_id_seq to todo_user`
- 
