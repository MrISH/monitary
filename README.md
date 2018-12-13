# Monitary

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.drop && mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`
  * Start Phoenix endpoint with interactive console using `iex -S mix phx.server`
  * List routes `mix phoenix.routes`

Now you can visit [`localhost:7777`](http://localhost:7777) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix


# What it is, Muns?
Track incoming and outgoing payments, both singular and recurring, maintaining a historical record for reference and analysis.
Transactions, therefore, must be able to contain details on the items transacted, categorised, tagged, and report-on-able.
Provide forecasts and suggestions based on history.

## Controllers

### Muns
#### #index
  - List me some Muns to view
  - Links to new/edit/destroy
### Sessions
#### #index
#### #login
#### #logout


## Models

### Mun
  - It is a entity that holds incoming and outgoing dollar values.
  - A transaction, by default, "recurs" once, based on `settlement_date`.
  - Incoming/Outgoing is determined by `classification` field, mapped to an array/hash_map of `{integer: :val}`
  - Payer/Payee is determined by `source` relationship
  - Can recur on many schedules, based on the `has_many :recurrences` relationship.
  `mix phx.gen.schema Mun muns name:string description:string user_id:integer`

### Transaction
  `mix phx.gen.schema Transaction transactions mun_id:integer user_id:integer amount_in_cents:integer settlement_date:naive_datetime classification:integer source_id:integer`

#### TransactionsItems
  `mix phx.gen.schema TransactionsItems transactions_items transaction_id:integer item_id:integer user_id:integer amount_in_cents:integer quantity:integer`

### Item
  `mix phx.gen.schema Item items name:string user_id:integer amount_in_cents:integer`

### Source
  `mix phx.gen.schema Source source name:string`
  `mix ecto.gen.migration create_transactions_sources`

### Recurrence


### User
  Does the auth
  Probably needs to be tied to entities as creator and last updator



## Development

### Seeds
```
  iex -S mix

  alias Monitary.Repo
  alias Monitary.Auth.User
  alias Monitary.Mun
  alias Monitary.Source
  alias Monitary.Transaction
  alias Monitary.Item
  alias Monitary.TransactionsItem

  Repo.all(User)
  Repo.insert(%User{username: "ish", password: "password"})
  current_user = Repo.get_by(User,%{username: "ish"})

  Repo.insert(%Mun{user_id: current_user.id, name: "A big Mun"})
  mun = Repo.get(Mun, 1)

  Repo.insert(%Source{name: "Wage"})
  source = Repo.get(Source, 1)

  Repo.insert(%Transaction{user_id: current_user.id, mun_id: mun.id, amount_in_cents: 1000, settlement_date: "2018-06-19T16:06:00.000Z", classification: 1, source_id: source.id})
  Repo.insert(%Transaction{user_id: current_user.id, mun_id: mun.id, amount_in_cents: 1000, settlement_date: ~N[2018-06-19 06:00:00], classification: 1, source_id: source.id})
  transaction = Repo.get(Transaction, 1)

  Repo.insert(%Item{name: "Milk", user_id: current_user.id})
  item = Repo.get(Item, 1)

  Repo.insert(%TransactionItem{transaction_id: transaction.id, item_id: item.id, user_id: current_user.id, amount_in_cents: 200, quantity: 1})

```








<!-- # -->
