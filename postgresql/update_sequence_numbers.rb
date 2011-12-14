#!/usr/bin/env ruby

require 'rubygems'
gem 'activerecord'
gem 'activesupport'
require 'active_record'
require 'active_record/base'
require 'active_support'

TABLES_WITHOUT_SEQUENCES = ["schema_migrations"]
TABLES_WITHOUT_UPDATED_AT = TABLES_WITHOUT_SEQUENCES + []

class PostgresqlModelBase < ActiveRecord::Base
  establish_connection(
    :adapter => "postgresql",
    :username => "username", # TODO: change this
    :password => "password", # TODO: change this
    :database => "database", # TODO: change this
    :encoding => "UTF8"
  )
end

PostgresqlModelBase.connection.tables.each_with_index do | table, table_index |
  puts "Processing table: #{table}"
  id_column = case table
              when "schema_migrations"
                "version"
              else
                "id"
              end

    # Set sequence values
    unless TABLES_WITHOUT_SEQUENCES.include?(table)
      sql_to_execute = "select setval('#{table}_#{id_column}_seq', (select max(#{id_column}) from #{table}))"
      puts "Executing: #{sql_to_execute}"
      PostgresqlModelBase.connection.execute(sql_to_execute)
    end
end
