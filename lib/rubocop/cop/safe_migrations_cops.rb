# frozen_string_literal: true
require "pry"

module RuboCop
  module Cop
    module Migration
      class UpdatingDataInMigration < RuboCop::Cop::Cop
        MSG = 'Updating or manipulating data in migration is unsafe!'.freeze

        def_node_matcher :update_all_in_migration?, <<-PATTERN
          (send _ ${:update_all} _+)
        PATTERN

        def_node_matcher :delete_all_in_migration?, <<-PATTERN
          (send _ :delete_all _?)
        PATTERN

        def_node_matcher :update_in_migration?, <<-PATTERN
          (send _ :update _+)
        PATTERN

        def on_send(node)
          # binding.pry
          update_all_in_migration?(node) { add_offense(node) }
          delete_all_in_migration?(node) { add_offense(node) }
          update_in_migration?(node) { add_offense(node) }
        end
      end
    end
  end
end