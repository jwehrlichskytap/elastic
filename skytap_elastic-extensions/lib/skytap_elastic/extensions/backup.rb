# encoding: utf-8

require 'pathname'
require 'fileutils'

require 'multi_json'
require 'oj'

require 'skytap_elastic'
require 'patron'

module Backup
  module Database

    # Integration with the Backup gem [http://backup.github.io/backup/v4/]
    #
    # This extension allows to backup Elastic indices as flat JSON files on the disk.
    #
    # @example Use the Backup gem's DSL to configure the backup
    #
    #     require 'elastic/extensions/backup'
    #
    #     Model.new(:elastic_backup, 'Elastic') do
    #
    #       database Elastic do |db|
    #         db.url     = 'http://localhost:9200'
    #         db.indices = 'articles,people'
    #         db.size    = 500
    #         db.scroll  = '10m'
    #       end
    #
    #       store_with Local do |local|
    #         local.path = '/tmp/backups'
    #         local.keep = 3
    #       end
    #
    #       compress_with Gzip
    #     end
    #
    # Perform the backup with the Backup gem's command line utility:
    #
    #     $ backup perform -t elastic_backup
    #
    # The Backup gem can store your backup files on S3, Dropbox and other
    # cloud providers, send notifications about the operation, and so on;
    # read more in the gem documentation.
    #
    # @example Use the integration as a standalone script (eg. in a Rake task)
    #
    #     require 'backup'
    #     require 'elastic/extensions/backup'
    #
    #     Backup::Logger.configure do
    #       logfile.enabled   = true
    #       logfile.log_path  = '/tmp/backups/log'
    #     end; Backup::Logger.start!
    #
    #     backup  = Backup::Model.new(:elastic, 'Backup Elastic') do
    #       database Backup::Database::Elastic do |db|
    #         db.indices = 'test'
    #       end
    #
    #       store_with Backup::Storage::Local do |local|
    #         local.path = '/tmp/backups'
    #       end
    #     end
    #
    #     backup.perform!
    #
    # @example A simple recover script for the backup created in the previous examples
    #
    #     PATH = '/path/to/backup/'
    #
    #     require 'elastic'
    #     client  = SkytapElastic::Client.new log: true
    #     payload = []
    #
    #     Dir[ File.join( PATH, '**', '*.json' ) ].each do |file|
    #       document = MultiJson.load(File.read(file))
    #       item = document.merge(data: document['_source'])
    #       document.delete('_source')
    #       document.delete('_score')
    #
    #       payload << { index: item }
    #
    #       if payload.size == 100
    #         client.bulk body: payload
    #         payload = []
    #       end
    #
    #       client.bulk body: payload
    #     end
    #
    # @see http://backup.github.io/backup/v4/
    #
    class SkytapElastic < Base
      class Error < ::Backup::Error; end

      attr_accessor :url,
                    :indices,
                    :size,
                    :scroll

      attr_accessor :mode

      def initialize(model, database_id = nil, &block)
        super

        @url     ||= 'http://localhost:9200'
        @indices ||= '_all'
        @size    ||= 100
        @scroll  ||= '10m'
        @mode    ||= 'single'

        instance_eval(&block) if block_given?
      end

      def perform!
        super

        case mode
          when 'single'
            __perform_single
          else
            raise Error, "Unsupported mode [#{mode}]"
        end

        log!(:finished)
      end

      def client
        @client ||= ::SkytapElastic::Client.new url: url, logger: logger
      end

      def path
        Pathname.new File.join(dump_path , dump_filename.downcase)
      end

      def logger
        logger = Backup::Logger.__send__(:logger)
        logger.instance_eval do
          def debug(*args);end
          # alias :debug :info
          alias :fatal :warn
        end
        logger
      end


      def __perform_single
        r = client.search index: indices, search_type: 'scan', scroll: scroll, size: size
        raise Error, "No scroll_id returned in response:\n#{r.inspect}" unless r['_scroll_id']

        while r = client.scroll(scroll_id: r['_scroll_id'], scroll: scroll) and not r['hits']['hits'].empty? do
          r['hits']['hits'].each do |hit|
            FileUtils.mkdir_p "#{path.join hit['_index'], hit['_type']}"
            File.open("#{path.join hit['_index'], hit['_type'], hit['_id']}.json", 'w') do |file|
              file.write MultiJson.dump(hit)
            end
          end
        end
      end
    end
  end
end

::Backup::Config::DSL::SkytapElastic = ::Backup::Database::SkytapElastic
