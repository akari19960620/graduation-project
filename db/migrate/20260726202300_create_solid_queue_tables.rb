class CreateSolidQueueTables < ActiveRecord::Migration[7.2]
  def change
    create_table :solid_queue_jobs do |t|
      t.string :queue_name, null: false
      t.string :class_name, null: false
      t.text :arguments
      t.integer :priority, default: 0, null: false
      t.string :active_job_id
      t.datetime :scheduled_at
      t.datetime :finished_at
      t.string :finished_with
      t.text :error

      t.timestamps

      t.index :queue_name
      t.index :priority
      t.index :scheduled_at
      t.index [ :finished_at, :finished_with ]
    end

    create_table :solid_queue_scheduled_executions do |t|
      t.references :job, null: false, foreign_key: { to_table: :solid_queue_jobs }
      t.datetime :scheduled_at, null: false

      t.timestamps

      t.index :scheduled_at
    end

    create_table :solid_queue_ready_executions do |t|
      t.references :job, null: false, foreign_key: { to_table: :solid_queue_jobs }
      t.integer :priority, default: 0, null: false

      t.timestamps

      t.index :priority
    end

    create_table :solid_queue_claimed_executions do |t|
      t.references :job, null: false, foreign_key: { to_table: :solid_queue_jobs }
      t.bigint :process_id
      t.datetime :claimed_at

      t.timestamps

      t.index [ :process_id, :claimed_at ]
    end

    create_table :solid_queue_blocked_executions do |t|
      t.references :job, null: false, foreign_key: { to_table: :solid_queue_jobs }
      t.string :queue_name, null: false
      t.integer :priority, default: 0, null: false
      t.string :concurrency_key

      t.timestamps

      t.index :concurrency_key
    end

    create_table :solid_queue_failed_executions do |t|
      t.references :job, null: false, foreign_key: { to_table: :solid_queue_jobs }
      t.text :error

      t.timestamps
    end

    create_table :solid_queue_pauses do |t|
      t.string :queue_name, null: false

      t.timestamps

      t.index :queue_name, unique: true
    end

    create_table :solid_queue_processes do |t|
      t.string :kind, null: false
      t.datetime :last_heartbeat_at, null: false
      t.bigint :supervisor_id

      t.timestamps

      t.index [ :last_heartbeat_at, :supervisor_id ]
    end

    create_table :solid_queue_semaphores do |t|
      t.string :key, null: false
      t.integer :value, default: 1, null: false

      t.timestamps

      t.index :key, unique: true
    end
  end
end
