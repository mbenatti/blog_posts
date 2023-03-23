# Elixir Blog Post graphql

 ### Created the support for Blog Posts
 - blog post with title, body and author
   
 ### Implement 2 queries:
 - listing blog posts
 - pulling a single blog post

 ### Implement 3 mutations:
 - creating a single blog post
 - editing a blog post
 - deleting a blog post
 - 
  ### restrictions:
 - only a blog post author can edit a blog post
 - only a blog post author can delete a blog post
 - only logged in users can create a blog post
 - 2 mentioned queries should be open to public


## Setup

### Development
- Copy contents of .env.local.example to .env.local
- Set config in .env.local
- source ./setenv.sh or ./run.sh to start app in dev mode

```bash
$ mix deps.get
$ mix ecto.create
$ mix ecto.migrate
```

### Run tests

```bash
$ mix test
```