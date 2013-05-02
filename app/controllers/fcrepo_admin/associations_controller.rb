module FcrepoAdmin
  # NOTE: This controller subclasses CatalogController, not ApplicationController
  class AssociationsController < CatalogController
    include FcrepoAdmin::Controller::CatalogControllerBehavior
    include FcrepoAdmin::Controller::AssociationsControllerBehavior
  end
end
