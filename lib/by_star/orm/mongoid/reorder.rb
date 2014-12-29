# Backport of `reorder` method from Origin 2.1.0+
if defined?(Origin::Optional) && !Origin::Optional.method_defined?(:reorder)
  module Origin
    module Optional

      # Instead of merging the order criteria, use this method to completely
      # replace the existing ordering with the provided.
      #
      # @example Replace the ordering.
      #   optional.reorder(name: :asc)
      #
      # @param [ Array, Hash, String ] spec The sorting specification.
      #
      # @return [ Optional ] The cloned optional.
      #
      # @since 2.1.0
      def reorder(*spec)
        options.delete(:sort)
        order_by(*spec)
      end
    end
  end
end
