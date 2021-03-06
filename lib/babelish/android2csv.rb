module Babelish
  require 'xmlsimple'
  class Android2CSV < Base2Csv

    def initialize(args = {:filenames => []})
      super(args)
    end

    def load_strings(strings_filename)
      strings = {}
      raise Errno::ENOENT unless File.exist?(strings_filename)

      xmlfile = XmlSimple.xml_in(strings_filename)
      xmlfile['string'].each do |element|
        if !element.nil? && !element['name'].nil?
          content = element['content'].nil? ? '' : element['content']
          strings.merge!({element['name'] => content})
        end
      end

      strings
    end

  end
end
