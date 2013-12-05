require 'atomutil'

module Paperclip
  module Storage
    module Atompub
      def self.extended(base)
        base.instance_eval do
          (@options.delete(:atompub_config) || {}).each do |key, value|
            @options[:"atompub_#{key}"] = value
          end
        end
      end

      def path(style_name = default_style)
        style_name
      end

      def url(style_name = default_style)
        attachment = atompub_attachment(style_name)
        attachment ? attachment.content_src : nil
      end

      def exists?(style_name = default_style)
        if original_filename
          ! atompub_entry(style_name).nil?
        else
          false
        end
      end
      
      def flush_writes #:nodoc:
        @queued_for_write.each do |style, file|
          begin
            log("saving #{path(style)}")
            attachment = atompub_attachment(style)
            attachment.resource_uri = atompub_client.create_media(options[:atompub_media_collection_uri], file.path, file.content_type, original_filename)
            attachment.content_src = atompub_client.get_entry(attachment.resource_uri).content.src
            attachment.save!
          ensure
            file.rewind
          end
        end
      end

      def flush_deletes #:nodoc:
        @queued_for_delete.each do |path|
          begin
            log("deleting #{path}")
            entry = atompub_entry(path)
            attachment = atompub_attachment(path).destroy
            attachment.destroy
            atompub_client.delete_media(entry.edit_media_link)
          rescue ::Atompub::RequestError
            # Ignore this.
          end
        end
        @queued_for_delete = []
      end

      private
      def atompub_auth
        @atompub_auth ||= ::Atompub::Auth::Wsse.new(atompub_credentials)
      end

      def atompub_client
        @atompub_client ||= begin
                              client = ::Atompub::Client.new(:auth => atompub_auth)
                              client.get_service(options[:atompub_service_uri])
                              client
                            end
        
      end

      def atompub_credentials
        @atompub_credentials ||= parse_credentials(options[:atompub_credentials]).with_indifferent_access
      end

      def parse_credentials(creds)
        creds = creds.respond_to?('call') ? creds.call(self) : creds
        creds = find_credentials(creds).stringify_keys
        env = Object.const_defined?(:Rails) ? Rails.env : nil
        (creds[env] || creds).symbolize_keys
      end

      def find_credentials(creds)
        case creds
        when File
          YAML::load(ERB.new(File.read(creds.path)).result)
        when String, Pathname
          YAML::load(ERB.new(File.read(creds)).result)
        when Hash
          creds
        else
          raise ArgumentError, "Credentials are not a path, file, proc, or hash."
        end
      end

      def atompub_attachment(style_name = default_style)
        PaperclipAtompub::Attachment.where(:style => style_name,
                                           :instance_type => self.instance.class.name,
                                           :instance_id => self.instance.id,
                                           :attachment_name => self.name).first_or_initialize
      end

      def atompub_entry(style_name = default_style)
        entry = atompub_attachment(style_name)
        return nil if entry.new_record?

        return atompub_client.get_entry(entry.resource_uri)
      rescue ::Atompub::RequestError
        return nil
      end

    end
  end
end
