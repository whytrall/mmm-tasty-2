class FixAllInvalidEncodings < ActiveRecord::Migration
  def self.up
    # First, get the database name
    db_name = select_value("SELECT DATABASE()")

    results = select_all(<<-SQL)
      SELECT 
        table_name,
        column_name,
        character_set_name,
        column_type,
        is_nullable,
        column_default,
        table_schema
      FROM information_schema.columns 
      WHERE table_schema = '#{db_name}'
      AND character_set_name IS NOT NULL 
      AND character_set_name != 'utf8'
      ORDER BY table_name, column_name
    SQL
    
    results.each do |row|
      table = row['table_name'].to_s.strip
      column = row['column_name'].to_s.strip
      type = row['column_type'].to_s.strip
      nullable = row['is_nullable'] == 'YES' ? '' : ' NOT NULL'
      default = row['column_default'] ? " DEFAULT #{quote(row['column_default'])}" : ''

      # Skip if table or column is blank
      if table.empty? || column.empty? || type.empty?
        next
      end

      # Update the column to utf8 while preserving NULL/NOT NULL and DEFAULT constraints
      sql = "ALTER TABLE `#{table}` MODIFY `#{column}` #{type} CHARACTER SET utf8 COLLATE utf8_unicode_ci#{nullable}#{default}"
      execute sql
    end

    table_results = select_all(<<-SQL)
      SELECT 
        table_name,
        table_schema,
        table_collation
      FROM information_schema.tables
      WHERE table_schema = '#{db_name}'
      AND table_collation != 'utf8_unicode_ci'
      AND table_type = 'BASE TABLE'
      ORDER BY table_name
    SQL

    table_results.each do |row|
      table = row['table_name'].to_s.strip
      
      if table.empty?
        next
      end

      execute "ALTER TABLE `#{table}` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci"
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration, "This migration cannot be reversed as it modifies multiple unknown columns"
  end
end 