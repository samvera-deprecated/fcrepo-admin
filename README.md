== Hydra Administrative Tool for a Fedora Repository

A Rails engine providing an administrative interface to a Fedora Commons repository built on the Hydra project framework.

=== Status

This project should be considered *experimental*. Versions earlier than 1.0 may change API and/or UI without notice 
or regard for backward compatibility.

=== Requirements

fcrepo_admin is designed for installation on hydra-head 6.0 or higher (requires active-fedora 6.1 or higher).
See https://github.com/projecthydra/hydra-head/wiki/Installation-Prerequisites.

=== Installation

(In the future, we hope to automate some of these tasks with a generator.)

* Add to gemfile

    gem 'fcrepo_admin'

  Then <code>bundle install</code>

* Run the Blacklight and Hydra generators (if this is a new Rails app, not an existing Hydra head)

    rails g blacklight --devise
    rails g hydra:head -f
    rake db:migrate
    rails g hydra:jetty  # if you need a development copy of jetty with solr and fedora

* Mount the engine

  In config/routes.rb add this line:

    mount FcrepoAdmin::Engine => '/', :as=> 'fcrepo_admin'

  You may use any mount point (except perhaps <code>'/catalog'</code>).
  All routes include <code>objects</code> as a subpath.

* Add CanCan action aliases (fcrepo_admin >= 0.4.0)

  In your Ability class (app/models/ability.rb) include the FcrepoAdmin::Ability module, for example:

    class Ability
      include Hydra::Ability
      include Hydra::PolicyAwareAbility
      include FcrepoAdmin::Ability
    end

  FcrepoAdmin::Ability defines action aliases for permissions which are enforced on (ActiveFedora::Base) objects.
  If your application defines action aliases, please check FcrepoAdmin::Ability for conflicts as aliases are global.

* Add Javascript (fcrepo_admin < 0.4.0)
  
  In app/assets/javascripts/application.js add:

    //= require bootstrap-tab

* Customize catalog search results (optional)

  If you would like catalog search results items to link to the fcrepo_admin object show view
  instead of the catalog show view, create app/helpers/blacklight_helper.rb with this content:

    module BlacklightHelper
      include Blacklight::BlacklightHelperBehavior  # Default Blacklight behaviors
      include FcrepoAdmin::Helpers::BlacklightHelperBehavior # fcrepo_admin overrides
      # additional customizations here, if any
    end

* Add audit trail support (optional)

  To enable access to the Fedora audit trail data through the fcrepo_admin UI, include the 
  ActiveFedora::Auditable mixin in your ActiveFedora models:

    include ActiveFedora::Auditable

=== Overriding fcrepo_admin behaviors

==== Configurable settings (fcrepo_admin >= 0.5.0)

To override default configurable settings for fcrepo_admin, create an initializer at config/initializers/fcrepo_admin.rb. 
You should start with this content:

    module YourApp
      class Application < Rails::Application
        config.before_initialize do
          # Customized settings will go here
        end
      end
    end

Refer to the default configuration settings at https://github.com/projecthydra/fcrepo-admin/blob/master/lib/fcrepo_admin/configurable.rb.

All configuration options are set by module methods prefixed by FcrepoAdmin, for example:

    FcrepoAdmin.read_only = true

==== Helpers

Override objects helpers by creating app/helpers/fcrepo_admin/objects_helper.rb with this content:

    module FcrepoAdmin::ObjectsHelper
      include FcrepoAdmin::Helpers::ObjectsHelperBehavior
      # override methods here
    end

In particular you may want to override #object_title.

Override datastreams helpers by creating app/helpers/fcrepo_admin/datastreams_helper.rb with this content:

    module FcrepoAdmin::DatastreamsHelper
      include FcrepoAdmin::Helpers::DatastreamsHelperBehavior
      # override methods here
    end    

==== Context Navigation Menus

===== fcrepo_admin >= 0.5.0

The configuration settings that control the items on the context menus are:

  FcrepoAdmin.object_nav_items = [:pid, :summary, :datastreams, :permissions, :associations, :audit_trail, :object_xml]
  FcrepoAdmin.datastream_nav_items = [:dsid, :version, :current_version, :summary, :content, :download, :edit, :upload, :history]

Each setting takes an array of symbols representing the items.  You can start by copying the default values shown above.
If you simply want to rearrange or remove items, then just modify the default arrays.

To add a custom navigation item, start by adding your own symbol to the approriate array setting.  Then override the 
appropriate helper method (see section above on overriding fcrepo_admin helpers) -- for object context nav, override 
#custom_object_nav_item in ObjectsHelper; for datastream context nav, override #custom_datastream_nav_item
in DatastreamsHelper.

Each method takes a single symbol argument and should return either nil (meaning no menu item is to be added) or the *content*
of a menu item.  Do not include the <li></li> wrapper.  You may want to use link_to_unless_current and/or put a condition on
the menu item (i.e., so that nil is returned if the condition is not met).

===== fcrepo_admin < 0.5.0

The contents of the object context navigation menu can be customized by overriding the #object_context_nav_items
helper method, or by copying and modifying the partial fcrepo_admin/objects/context_nav_items.

The contents of the datastream context navigation menu can be customized by overriding the 
#datastream_context_nav_items helper method, or by copying and modifying the partial fcrepo_admin/datastreams/context_nav_items.

==== Controllers

To override or extend controller behaviors, please consult Rails engine documentation and guides, such as 
http://edgeguides.rubyonrails.org/engines.html.

IMPORTANT: If you add a non-RESTful action to a controller, you will probably have to add a CanCan action alias
to your Ability class.  For this, you can use Hydra's #custom_permissions callback:

    class Ability
      include Hydra::Ability
      include Hydra::PolicyAwareAbility
      include FcrepoAdmin::Ability

      def custom_permissions
        alias_action :my_method, :to => :read
      end

    end  

==== Read-only mode

To suppress mutating behaviors (i.e, routes, nav items, etc.) regardless of user permissions, 
add this configuration setting:

  FcrepoAdmin.read_only = true

=== Internationalization (i18n)

An effort has been made to support i18n on headings, menus, etc.  See https://github.com/projecthydra/fcrepo-admin/blob/master/config/locales/fcrepo_admin.en.yml
for the keys and consult the Rails documentation on how to provide your own translations or alternate text values.

=== Contributing

* Consider first posting to hydra-tech@googlegroups.com with a question or bug report, or submit an issue
  to the Github issue tracker at https://github.com/projecthydra/fcrepo-admin/issues.
* Fork the git repository, create a feature branch, make your changes, and submit a pull request.  
  It is preferable for all changes to be made in one commit, if possible.

Thanks!

=== License

See the LICENSE file in the root directory of the project for copyright and license information.

Licenses for code copied from other projects will be included in source files as required.