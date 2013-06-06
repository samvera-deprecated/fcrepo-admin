require 'rspec/core'
require 'rspec/core/rake_task'
APP_ROOT="." # for jettywrapper
require 'jettywrapper'
ENV["RAILS_ROOT"] ||= 'spec/internal'

desc "Run specs"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "--colour"
end
namespace :fcrepo_admin do
    desc "CI Build"
    task :ci do
		ENV['environment'] = "test"
		Rake::Task["jetty:clean"].invoke
  		jetty_params = Jettywrapper.load_config
  		jetty_params[:startup_wait] = 60
  		Jettywrapper.wrap(jetty_params) do
    	    Rake::Task['spec'].invoke
  		end
	end
    namespace :solr do
        desc "Deletes everything from the Solr index"
        task :clean => :environment do
          Blacklight.solr.delete_by_query("*:*")
          Blacklight.solr.commit
        end
        desc "Index a single object in solr specified by PID="
        task :index => :environment do
          raise "Must specify a pid. Ex: PID=changeme:12" unless ENV['PID']
          ActiveFedora::Base.connection_for_pid('foo:1') # Loads Rubydora connection with fake object
          ActiveFedora::Base.find(ENV['PID'], cast: true).update_index
        end
        desc 'Index all objects in the repository (except fedora-system: objects).'
        task :index_all => :environment do
          ActiveFedora::Base.connection_for_pid('foo:1') # Loads Rubydora connection with fake object
          ActiveFedora::Base.fedora_connection[0].connection.search(nil) do |object|
            if !object.pid.starts_with?('fedora-system:')
                ActiveFedora::Base.find(object.pid, cast: true).update_index
            end
          end
        end        
    end
end