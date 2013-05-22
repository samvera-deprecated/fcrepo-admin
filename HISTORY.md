==== 0.5.2 (2013-05-22)

* Fixed association show view pagination by working around Kaminari.
* Object XML (FOXML) accessible from object context nav.
* Catalog show fields and show document actions displayed in object show view (summary).

==== 0.5.1 (2013-05-21)

* Association show view paginated (Fixes #18). 
* Association show view uses blacklight document list rendering.
* Object show view loads Solr document for object and incorporates Blacklight document show fields.

=== 0.5.0 (2013-05-17)

* Feature: Configurable settings.
* Context navigation menus refactored: customizations now done through helpers and configuration settings, not by overriding partials.
* ActiveFedora::Base and ActiveFedora::Datastream classes extended by decorators.
* Tests added.

==== 0.4.1 (2013-05-14)

* Feature: Datastream history view.
* Feature: Support for asOfDateTime parameter added to datastream read views to display content and profile information for datastream versions.

=== 0.4.0 (2013-05-03)

* Feature: Display object's associations.
* Require inclusion of CanCan action aliases in application's Ability class.
* Tabbed object show view ("summary") replaced with separate views.

==== 0.3.5 (2013-04-30)

* Requires active-fedora 6.1.

==== 0.3.4 (2013-04-29)

* Moved FcrepoAdmin::BlacklightHelperBehavior to FcrepoAdmin::Helpers::BlacklightHelperBehavior.
* FcrepoAdmin::ObjectsHelper methods can now be easily overridden.
* FcrepoAdmin::DatastreamsHelper module added.
* Shared helper methods in new module FcrepoAdmin::Helpers::FcrepoAdminHelperBehavior.
* Objects and datastreams controller behaviors are now easily overrideable.
* Refactored object and datastream context navs for greater reusability.

==== 0.3.3 (2013-04-25)

* Audit trail functionality fails gracefully (i.e., if object does not implement ActiveFedora::Auditable)

==== 0.3.2 (2013-04-19)

* Separated datastream and object context navigation menus.
* Added object helpers.

==== 0.3.1 (2013-04-18)

* Object and datastream context nav menus added.
* Audit trail moved into objects controller.

=== 0.3.0 (2013-04-16)

* Feature: Permissions and inherited permissions added to object show view.

=== 0.2.0 (2013-04-12)

* Feature: Datastream content editing.

=== 0.1.0 (2013-04-11)

Initial release to RubyGems.

