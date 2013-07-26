## Hydra Administrative Tool for a Fedora Repository

A Rails engine providing an administrative interface to a Fedora Commons repository built on the Hydra project framework.

### Status

[![Build Status](https://travis-ci.org/projecthydra/fcrepo-admin.png?branch=master)](https://travis-ci.org/projecthydra/fcrepo-admin)

This project should be considered *experimental*. Versions earlier than 1.0 may change API and/or UI without notice 
or regard for backward compatibility.

### Requirements

fcrepo_admin is designed for installation on hydra-head 6.0 or higher (requires active-fedora 6.1 or higher).
See https://github.com/projecthydra/hydra-head/wiki/Installation-Prerequisites.

### Installation

**Prerequisite**

An existing Hydra head. If you are starting from scratch, see https://github.com/projecthydra/hydra-head for instructions on creating a new Hydra head.

**Add to Gemfile**

```
gem 'fcrepo_admin'
```

Then `bundle install`

**Mount the engine**

In `config/routes.rb` add this line:

```ruby
mount FcrepoAdmin::Engine => '/', :as=> 'fcrepo_admin'
```

You may use any mount point.  All routes include `objects` as a subpath.

**Add CanCan action aliases** (fcrepo_admin >= 0.4.0)

In your Ability class (`app/models/ability.rb`) include the `FcrepoAdmin::Ability` module, for example:

```ruby
class Ability
  include Hydra::Ability
  include Hydra::PolicyAwareAbility
  include FcrepoAdmin::Ability
end
```

`FcrepoAdmin::Ability` defines action aliases for permissions which are enforced on `ActiveFedora::Base` objects.
If your application defines action aliases, please check `FcrepoAdmin::Ability` for conflicts as aliases are global.

**Customize catalog search results** (optional)

If you would like catalog search results items to link to the fcrepo_admin object show view
instead of the catalog show view, create `app/helpers/blacklight_helper.rb` with this content:

```ruby
module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior  # Default Blacklight behaviors
  include FcrepoAdmin::Helpers::BlacklightHelperBehavior # fcrepo_admin overrides
end
```

If you have an existing custom blacklight helper module, simply include `FcrepoAdmin::Helpers::BlacklightHelperBehavior`
*after* `Blacklight::BlacklightHelperBehavior`.

**Add audit trail support** (optional)

To enable access to the Fedora audit trail data through the fcrepo_admin UI, include the 
`ActiveFedora::Auditable` mixin in your ActiveFedora models:

```ruby
include ActiveFedora::Auditable
```

### Overriding fcrepo_admin behaviors

#### Configurable settings (fcrepo_admin >= 0.5.0)

To override default configurable settings for fcrepo_admin, create an initializer at `config/initializers/fcrepo_admin.rb`.
You should start with this content:

```ruby
module YourApp
  class Application < Rails::Application
    config.before_initialize do
      # Customized settings will go here
    end
  end
end
```

Refer to the default configuration settings at https://github.com/projecthydra/fcrepo-admin/blob/master/lib/fcrepo_admin/configurable.rb.

All configuration options are set by module methods prefixed by `FcrepoAdmin`, for example:

```ruby
FcrepoAdmin.read_only = true
```

#### Helpers

Override objects helpers by creating `app/helpers/fcrepo_admin/objects_helper.rb` with this content:

```ruby
module FcrepoAdmin::ObjectsHelper
  include FcrepoAdmin::Helpers::ObjectsHelperBehavior
  # override methods here
end
```

In particular you may want to override `object_title`.

Override datastreams helpers by creating `app/helpers/fcrepo_admin/datastreams_helper.rb` with this content:

```ruby
module FcrepoAdmin::DatastreamsHelper
  include FcrepoAdmin::Helpers::DatastreamsHelperBehavior
  # override methods here
end
```    

#### Context Navigation Menus

##### fcrepo_admin >= 0.5.0

The configuration settings that control the items on the context menus are:

```ruby
FcrepoAdmin.object_nav_items = [:pid, :summary, :datastreams, :permissions, :associations, :audit_trail, :object_xml]
FcrepoAdmin.datastream_nav_items = [:dsid, :version, :current_version, :summary, :content, :download, 
                                    :edit, :upload, :history]
```

Each setting takes an array of symbols representing the items.  You can start by copying the default values shown above.
If you simply want to rearrange or remove items, then just modify the default arrays.

To add a custom navigation item, start by adding your own symbol to the approriate array setting.  Then override the 
appropriate helper method (see section above on overriding fcrepo_admin helpers) -- for object context nav, override 
`custom_object_nav_item` in `ObjectsHelper`; for datastream context nav, override `custom_datastream_nav_item`
in `DatastreamsHelper`.

Each method takes a single symbol argument and should return either nil (meaning no menu item is to be added) or the 
*content* of a menu item.  Do not include the `<li></li>` wrapper.  You may want to use `link_to_unless_current` 
and/or put a condition on the menu item (i.e., so that `nil` is returned if the condition is not met).

##### fcrepo_admin < 0.5.0

The contents of the object context navigation menu can be customized by overriding the `object_context_nav_items`
helper method, or by copying and modifying the partial `fcrepo_admin/objects/context_nav_items`.

The contents of the datastream context navigation menu can be customized by overriding the 
`datastream_context_nav_items` helper method, or by copying and modifying the partial 
`fcrepo_admin/datastreams/context_nav_items`.

#### Controllers

To override or extend controller behaviors, please consult Rails engine documentation and guides, such as 
http://edgeguides.rubyonrails.org/engines.html.

IMPORTANT: If you add a non-RESTful action to a controller, you will probably have to add a CanCan action alias
to your Ability class.  For this, you can use Hydra's `custom_permissions` callback:

```ruby
class Ability
  include Hydra::Ability
  include Hydra::PolicyAwareAbility
  include FcrepoAdmin::Ability

  def custom_permissions
    alias_action :my_method, :to => :read
  end
end
```  

#### Associations

Due to the way Rails resolves relative paths to partials, in order to use Blacklight's default document index view behavior
on the associations show page and avoid missing template errors, fcrepo_admin provides a custom document partial at 
`fcrepo_admin/catalog/document` that renders the partial at `catalog/document`, for which Blacklight provides a default.
If you have a custom document partial at a different path that you want to use for the document list on the associations 
show page, you *may* be able to simply copy it to `app/views/fcrepo_admin/catalog/document`, or you might try putting 
this content in that file:

```
<%= render :partial => 'path/to/my/document', :locals => { :document => document, :document_counter => document_counter } %>
```

replacing the partial path as appropriate.  If anyone has a better solution or knows of a way to avoid providing the 
document partial in fcrepo_admin admin, please submit a pull request.

#### Blacklight document actions

Blacklight's default show page for a document (i.e., Solr document for, in this case, an ActiveFedora object) includes a menu
of actions, including a bookmark function.  In order to provide the most flexible interface with a focus on repository "administrative"
functions, we have not included this content in the default fcrepo_admin views.  However, since the fcrepo_admin object show view
includes the Solr document in its context, you could re-add this functionality by overriding the default template at
`fcrepo_admin/objects/show.html.erb` or by overriding the catalog show partial which that views renders.

#### Read-only mode

To suppress mutating behaviors (i.e, routes, nav items, etc.) regardless of user permissions, 
add this configuration setting:

```ruby
FcrepoAdmin.read_only = true
```

### Internationalization (i18n)

An effort has been made to support i18n on headings, menus, etc.  See https://github.com/projecthydra/fcrepo-admin/blob/master/config/locales/fcrepo_admin.en.yml
for the keys and consult the Rails documentation on how to provide your own translations or alternate text values.

### Known Issues

#### Pagination

Kaminari as of version 0.14.1 does not support namespace-prefixed routes, which causes a routing error in Blacklight's 
`paginate_rsolr_response` helper when called from within fcrepo_admin.  In place of `paginate_rsolr_response` fcrepo_admin
use its own helper `safe_paginate_rsolr_response` which provides a basic set of pagination links without using Kaminari.  

There is (as of 2013-05-24) an outstanding Kaminari pull request which resolves the routing issue (https://github.com/amatsuda/kaminari/pull/322).
You can implement this solution by adding to your application's Gemfile:

```
gem 'kaminari', github: 'harai/kaminari', branch: 'route_prefix_prototype'
```

and then override the `safe_paginate_rsolr_response` helper with something like:

```ruby
def safe_paginate_rsolr_response(response)
  paginate_rsolr_response response, :outer_window => 2, :theme => 'blacklight', :route_set => fcrepo_admin
end
```

the key part being the `:route_set` option -- note that the value is not a string -- with gets passed through to Kaminari.

If Kaminari is suitably patched in the future, we will likely remove `safe_paginate_rsolr_response` in favor of
`paginate_rsolr_response`.

### Contributing

See `CONTRIBUTING.md` in the root of the project.

### License

See the `LICENSE` file in the root directory of the project for copyright and license information.

Licenses for code copied from other projects will be included in source files as required.
