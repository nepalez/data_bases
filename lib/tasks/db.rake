# Redefine ActiveRecord db rake tasks, that are sequence of tasks defined for
# single databases.
%w(
  abort_if_pending_migrations
  check_protected_environments
  create
  create:all
  drop
  drop:_unsafe
  drop:all
  fixtures:load
  forward
  migrate
  migrate:down
  migrate:redo
  migrate:reset
  migrate:up
  purge
  reset
  rollback
  seed
  setup
  test:load
  test:prepare
  test:purge
  version
).each do |name|
  Rake::Task["db:#{name}"].clear
  task "db:#{name}" => DataBases.keys.map { |key| "db:#{key}:#{name}" }
end
