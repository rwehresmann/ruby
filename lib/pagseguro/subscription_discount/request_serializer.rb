module PagSeguro
  class SubscriptionDiscount
    class RequestSerializer
      attr_reader :object

      def initialize(object)
        @object = object
      end

      def to_xml_params
        xml_builder.to_xml(
          save_with:
          Nokogiri::XML::Node::SaveOptions::NO_EMPTY_TAGS |
          Nokogiri::XML::Node::SaveOptions::FORMAT
        )
      end

      private

      def to_amount(amount)
        "%.2f" % to_bigdecimal(amount.to_s).round(2) if amount
      end

      def xml_builder
        Nokogiri::XML::Builder.new(encoding: PagSeguro.encoding) do |xml|
          xml.send(:directPreApproval) {
            xml.send(:type, object.type)
            xml.send(:value, to_amount(object.value))
          }
        end
      end

      def to_bigdecimal(value)
        BigDecimal(value)
      rescue Exception => e
        0
      end
    end
  end
end
