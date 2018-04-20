class AddSomeIndexsToSomeTables < ActiveRecord::Migration[5.1]
  def change
    add_index :bookshelf_supplements, :state
    add_index :bookshelf_supplements, :audit_state
    add_index :bookshelf_supplements, :project_season_apply_bookshelf_id, name: 'index_bookshelf_supplements_on_bookshelf_id'
    add_index :bookshelf_supplements, :project_season_apply_id

    add_index :campaign_enlists, :campaign_id

    add_index :donate_records, :donor_id
    add_index :donate_records, :project_id
    add_index :donate_records, :project_season_apply_id, name: 'index_donate_records_on_apply_id'
    add_index :donate_records, :gsh_child_id
    add_index :donate_records, :donation_id
    add_index :donate_records, :project_season_apply_child_id, name: 'index_donate_records_on_apply_child_id'

    add_index :donations, :pay_state
    add_index :donations, :donor_id
    add_index :donations, :team_id
    add_index :donations, :project_id
    add_index :donations, :project_season_apply_id

    add_index :gsh_child_grants, :state
    add_index :gsh_child_grants, :donate_state
    add_index :gsh_child_grants, :grant_batch_id
    add_index :gsh_child_grants, :project_season_apply_child_id, name: 'index_gsh_child_grants_on_apply_child_id'

    add_index :income_records, :voucher_state
    add_index :income_records, :donor_id
    add_index :income_records, :donation_id
    add_index :income_records, :agent_id
    add_index :income_records, :team_id

    add_index :project_season_applies, :audit_state
    add_index :project_season_applies, :camp_state
    add_index :project_season_applies, :read_state
    add_index :project_season_applies, :execute_state
    add_index :project_season_applies, :pair_state
    add_index :project_season_applies, :project_id
    add_index :project_season_applies, :school_id
    add_index :project_season_applies, :teacher_id

    add_index :project_season_apply_bookshelves, :state
    add_index :project_season_apply_bookshelves, :audit_state
    add_index :project_season_apply_bookshelves, :project_season_apply_id, name: 'index_bookshelves_on_apply_id'

    add_index :project_season_apply_camps, :project_season_apply_id, name: 'index_apply_camps_on_apply_id'
    add_index :project_season_apply_camps, :execute_state

    add_index :task_volunteers, :state
    add_index :task_volunteers, :task_id
    add_index :task_volunteers, :volunteer_id

  end
end
