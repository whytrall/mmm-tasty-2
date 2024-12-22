module AssetGluer
  class JavascriptFile < AssetFile
    def self.dir
      File.join(AssetGluer.asset_dir, 'javascripts')
    end

    def process
      contents = File.read(@absolute_path)

      contents = process_with_coffee(contents) if @absolute_path.ends_with?('.coffee')

      contents
    end

    def self.process(contents)
      # uglifier requires special care, disabled
      contents = self.process_with_uglifier(contents) if Rails.env.production?

      contents
    end

    def self.process_with_uglifier(contents)
      require 'uglifier'

      Uglifier.compile contents, TASTY_ASSETS[:compressor_options].symbolize_keys!
    end

    protected
      def process_with_coffee(contents)
        Rails.cache.fetch "gluer:js:coffee:#{Digest::SHA1.hexdigest(contents)}", :expires_in => 1.day do
          begin
            coffee_path = which_coffee
            raise "CoffeeScript compiler not found. Please install it with 'npm install -g coffee-script'" unless coffee_path

            IO.popen "#{coffee_path} -bsc", 'r+' do |io|
              io.write(contents)
              io.close_write
              io.read
            end
          rescue Errno::ENOENT => e
            Rails.logger.error "CoffeeScript compilation failed: #{e.message}"
            raise "CoffeeScript compiler not found. Please install it with 'npm install -g coffee-script'"
          rescue => e
            Rails.logger.error "CoffeeScript compilation failed: #{e.message}"
            raise "Failed to compile CoffeeScript: #{e.message}"
          end
        end
      end

      private
        def which_coffee
          exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
          ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
            exts.each do |ext|
              coffee = File.join(path, "coffee#{ext}")
              return coffee if File.executable?(coffee) && !File.directory?(coffee)
            end
          end
          nil
        end

  end
end
