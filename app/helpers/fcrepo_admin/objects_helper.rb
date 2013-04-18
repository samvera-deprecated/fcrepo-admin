module FcrepoAdmin
  module ObjectsHelper

    def object_title
      "#{@object.class.to_s} #{@object.pid}"
    end

  end
end
