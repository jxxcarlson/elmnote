
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

[{"id":"f463ec52-8f43-4ab0-9a27-6506b0b59bc7","created_on":"2018-10-30T14:13:10","modfied_on":"2018-10-30T14:13:10","title":"This is a test.","note":"This is a test."},

 {"id":"5a64c5db-0f26-4385-80c6-113e5e8b06ce","created_on":"2018-10-30T14:13:10","modfied_on":"2018-10-30T14:13:10","title":"MathJax: http://docs.mathjax.org/en/latest/api/hub.html?highlight=elements // 2018-10-29","note":"MathJax: http://docs.mathjax.org/en/latest/api/hub.html?highlight=elements // 2018-10-29"},

 {"id":"6fca9b47-352d-4c7c-b585-15c0d2ef6b14","created_on":"2018-12-03T04:34:19","modfied_on":"2018-12-03T04:34:19","title":"Test","note":"Test\nABC\nDEF\n\n"}]


[{"id":"15e7bfee-c195-4310-bf08-f1f7f0ebee4b","created_on":"2018-11-11T14:22:40","modfied_on":"2018-11-11T14:22:40","title":"Why Competition in the Politics Industry is Failing America","note":"Why Competition in the Politics Industry is Failing America\nHarvard Business School Review\nhttps://www.hbs.edu/competitiveness/Documents/why-competition-in-the-politics-industry-is-failing-america.pdf"}]

  curl http://localhost:3000/notes -X PATCH \
       -H "Authorization: Bearer $TOKEN"    \
       -H "Content-Type: application/json"  \
       -d '{"done": true}'

037b75e1-ae57-49f1-8431-03b7c21f278c

eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoibm90ZXNfdXNlciJ9.zKIQmp43fuXaCQyaBZT6sLsJ0nyVLZHwQZHJIMAoXw8
db-uri = "postgres://postgres:mysecretpassword@localhost/info"
db-schema = "api"
db-anon-role = "web_anon"
jwt-secret = "YBKObw8DoFZ26Q4Tne9qWpxfsMyeq6a2"


jwt-secret2 = "R5f4YAyPjss3GeQt7FRJQaLXrekm0tDG"
jwt2 = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidG9kb191c2VyIn0.vGRCjfzpREaTqG4b5ga48u54S1lkjc43JOrQgc-2PQM"


curl http://localhost:3000/todos -X POST \
     -H "Authorization: Bearer $TODO_TOKEN"   \
     -H "Content-Type: application/json" \
     -d '{"task": "learn how to auth"}'
