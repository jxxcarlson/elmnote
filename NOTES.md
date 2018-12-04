
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


curl http://localhost:3000/notes -X POST -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoibm90ZXNfdXNlciJ9.zKIQmp43fuXaCQyaBZT6sLsJ0nyVLZHwQZHJIMAoXw8" -H "Content-Type: application/json" -d '{"title": "xxx", "note": "yyy"}'

curl http://localhost:3000/notes?id=eq.e595bbd9-a7cb-40be-a153-22a6bb96bbcc -X PATCH -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoibm90ZXNfdXNlciJ9.zKIQmp43fuXaCQyaBZT6sLsJ0nyVLZHwQZHJIMAoXw8" -H "Content-Type: application/json"  -d '{"note": "test\nxxxx\n"}'

curl http://localhost:3000/notes?id=eq.e595bbd9-a7cb-40be-a153-22a6bb96bbcc
curl http://localhost:3000/notes?title=ilike.*test*
curl http://localhost:3000/notes?note=ilike.*why*




curl http://localhost:3000/notes -X PATCH \
     -H "Authorization: Bearer $TOKEN"    \
     -H "Content-Type: application/json"  \
     -d '{"done": true}'



jwt-secret2 = "R5f4YAyPjss3GeQt7FRJQaLXrekm0tDG"
jwt2 = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidG9kb191c2VyIn0.vGRCjfzpREaTqG4b5ga48u54S1lkjc43JOrQgc-2PQM"


curl http://localhost:3000/todos -X POST \
     -H "Authorization: Bearer $TODO_TOKEN"   \
     -H "Content-Type: application/json" \
     -d '{"task": "learn how to auth"}'

## VIEWS

  curl http://localhost:3000/count_notes

```
CREATE VIEW count_notes AS
SELECT count(*)
  FROM notes;
```
