module FcrepoAdmin
  class ObjectsController < CatalogController
    include FcrepoAdmin::Controller::CatalogControllerBehavior
    include FcrepoAdmin::Controller::ObjectsControllerBehavior
  end
end
