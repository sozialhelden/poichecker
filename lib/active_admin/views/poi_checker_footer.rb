module ActiveAdmin
  module Views
    class PoiCheckerFooter < ActiveAdmin::Component
      def build
        super(id: "footer")
        para "Copyright #{Date.today.year} SOZIALHELDEN e.V."
      end
    end
  end
end