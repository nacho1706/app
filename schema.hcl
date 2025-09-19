table "categories" {
  schema = schema.go_db
  column "id" {
    null           = false
    type           = bigint
    auto_increment = true
  }
  column "user_id" {
    null = true
    type = bigint
  }
  column "name" {
    null = false
    type = varchar(80)
  }
  column "type" {
    null = false
    type = enum("expense","income")
  }
  primary_key {
    columns = [column.id]
  }
  foreign_key "categories_ibfk_1" {
    columns     = [column.user_id]
    ref_columns = [table.users.column.id]
    on_update   = NO_ACTION
    on_delete   = NO_ACTION
  }
  index "user_id" {
    unique  = true
    columns = [column.user_id, column.name, column.type]
  }
}
table "failed_jobs" {
  schema  = schema.go_db
  collate = "utf8mb4_unicode_ci"
  column "id" {
    null           = false
    type           = bigint
    unsigned       = true
    auto_increment = true
  }
  column "uuid" {
    null = false
    type = varchar(255)
  }
  column "connection" {
    null = false
    type = text
  }
  column "queue" {
    null = false
    type = text
  }
  column "payload" {
    null = false
    type = longtext
  }
  column "exception" {
    null = false
    type = longtext
  }
  column "failed_at" {
    null    = false
    type    = timestamp
    default = sql("CURRENT_TIMESTAMP")
  }
  primary_key {
    columns = [column.id]
  }
  index "failed_jobs_uuid_unique" {
    unique  = true
    columns = [column.uuid]
  }
}
table "job_batches" {
  schema  = schema.go_db
  collate = "utf8mb4_unicode_ci"
  column "id" {
    null = false
    type = varchar(255)
  }
  column "name" {
    null = false
    type = varchar(255)
  }
  column "total_jobs" {
    null = false
    type = int
  }
  column "pending_jobs" {
    null = false
    type = int
  }
  column "failed_jobs" {
    null = false
    type = int
  }
  column "failed_job_ids" {
    null = false
    type = longtext
  }
  column "options" {
    null = true
    type = mediumtext
  }
  column "cancelled_at" {
    null = true
    type = int
  }
  column "created_at" {
    null = false
    type = int
  }
  column "finished_at" {
    null = true
    type = int
  }
  primary_key {
    columns = [column.id]
  }
}
table "jobs" {
  schema  = schema.go_db
  collate = "utf8mb4_unicode_ci"
  column "id" {
    null           = false
    type           = bigint
    unsigned       = true
    auto_increment = true
  }
  column "queue" {
    null = false
    type = varchar(255)
  }
  column "payload" {
    null = false
    type = longtext
  }
  column "attempts" {
    null     = false
    type     = tinyint
    unsigned = true
  }
  column "reserved_at" {
    null     = true
    type     = int
    unsigned = true
  }
  column "available_at" {
    null     = false
    type     = int
    unsigned = true
  }
  column "created_at" {
    null     = false
    type     = int
    unsigned = true
  }
  primary_key {
    columns = [column.id]
  }
  index "jobs_queue_index" {
    columns = [column.queue]
  }
}
table "migrations" {
  schema  = schema.go_db
  collate = "utf8mb4_unicode_ci"
  column "id" {
    null           = false
    type           = int
    unsigned       = true
    auto_increment = true
  }
  column "migration" {
    null = false
    type = varchar(255)
  }
  column "batch" {
    null = false
    type = int
  }
  primary_key {
    columns = [column.id]
  }
}
table "transactions" {
  schema = schema.go_db
  column "id" {
    null           = false
    type           = bigint
    auto_increment = true
  }
  column "user_id" {
    null = false
    type = bigint
  }
  column "type" {
    null = false
    type = enum("gasto","ingreso")
  }
  column "amount" {
    null     = false
    type     = decimal(12,2)
    unsigned = false
  }
  column "currency" {
    null    = false
    type    = char(3)
    default = "ARG"
  }
  column "conversion_rate" {
    null     = false
    type     = decimal(12,6)
    unsigned = false
  }
  column "category_id" {
    null = true
    type = bigint
  }
  column "description" {
    null = true
    type = varchar(255)
  }
  column "tx_date" {
    null = false
    type = date
  }
  column "created_at" {
    null    = true
    type    = timestamp
    default = sql("CURRENT_TIMESTAMP")
  }
  column "updated_at" {
    null      = true
    type      = timestamp
    default   = sql("CURRENT_TIMESTAMP")
    on_update = sql("CURRENT_TIMESTAMP")
  }
  primary_key {
    columns = [column.id]
  }
  foreign_key "transactions_ibfk_1" {
    columns     = [column.user_id]
    ref_columns = [table.users.column.id]
    on_update   = NO_ACTION
    on_delete   = NO_ACTION
  }
  foreign_key "transactions_ibfk_2" {
    columns     = [column.category_id]
    ref_columns = [table.categories.column.id]
    on_update   = NO_ACTION
    on_delete   = NO_ACTION
  }
  index "category_id" {
    columns = [column.category_id]
  }
  index "ftx_desc" {
    columns = [column.description]
    type    = FULLTEXT
  }
  index "idx_user_category_date" {
    columns = [column.user_id, column.category_id, column.tx_date]
  }
  index "idx_user_date" {
    columns = [column.user_id, column.tx_date]
  }
}
table "user_preferences" {
  schema = schema.go_db
  column "user_id" {
    null = false
    type = bigint
  }
  column "pref_key" {
    null = false
    type = varchar(60)
  }
  column "pref_value" {
    null = false
    type = json
  }
  primary_key {
    columns = [column.user_id, column.pref_key]
  }
  foreign_key "user_preferences_ibfk_1" {
    columns     = [column.user_id]
    ref_columns = [table.users.column.id]
    on_update   = NO_ACTION
    on_delete   = NO_ACTION
  }
}
table "users" {
  schema = schema.go_db
  column "id" {
    null           = false
    type           = bigint
    auto_increment = true
  }
  column "account_id" {
    null = false
    type = bigint
  }
  column "first_name" {
    null = true
    type = varchar(100)
  }
  column "created_at" {
    null    = true
    type    = timestamp
    default = sql("CURRENT_TIMESTAMP")
  }
  column "last_seen" {
    null    = true
    type    = datetime
    default = sql("CURRENT_TIMESTAMP")
  }
  column "currency" {
    null    = true
    type    = char(3)
    default = "ARS"
  }
  column "locale" {
    null    = true
    type    = varchar(10)
    default = "es-AR"
  }
  column "timezone" {
    null    = true
    type    = varchar(50)
    default = "America/Argentina/Buenos_Aires"
  }
  primary_key {
    columns = [column.id]
  }
  index "telegram_id" {
    unique  = true
    columns = [column.account_id]
  }
}
schema "go_db" {
  charset = "utf8mb4"
  collate = "utf8mb4_0900_ai_ci"
}
