module ActiveAdmin
  module Views
    class PoiCheckerFooter < ActiveAdmin::Component
      def build
        super(id: "footer")
        render partial: 'shared/footer'
      end
    end
  end
end