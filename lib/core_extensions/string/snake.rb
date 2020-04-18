module CoreExtensions
  class String
    module Snake
      def snake
        self.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
          .gsub(/([a-z\d])([A-Z])/,'\1_\2')
          .tr('-', '_').gsub(/\s/, '_')
          .gsub(/__+/, '_')
          .downcase
          .gsub(/[^0-9a-z _]/i, '')
      end
    end
  end
end
