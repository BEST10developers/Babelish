module Babelish
  class Strings2CSV < Base2Csv
    # default_lang is the the column to refer to if a value is missing
    # actually default_lang = default_filename
    attr_accessor :csv_filename, :headers, :filenames, :default_lang

    def initialize(args = {:filenames => []})
      super(args)
    end

    def parse_dotstrings_line(line)
      line.strip!
      if line[0] != ?# && line[0] != ?= && line[0] != ?/
        m = line.match(/^[^\"]*\"(.+)\"[^=]+=[^\"]*\"(.*)\";/)
        return {m[1] => m[2]} unless m.nil?
      end
    end

    # Load all strings of a given file
    def load_strings(strings_filename)
      strings = {}

      # genstrings uses utf16, so that's what we expect. utf8 should not be impact
      file = File.open(strings_filename, "r:utf-16:utf-8")
      begin
        contents = file.read
        if RUBY_VERSION == "1.9.2"
          # fixes conversion, see http://po-ru.com/diary/fixing-invalid-utf-8-in-ruby-revisited/
          require 'iconv'
          ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
          contents = ic.iconv(contents + ' ')[0..-2]
        end
      rescue Encoding::InvalidByteSequenceError => e
        # silent error
        # faults back to utf8
        contents = File.open(strings_filename, "r:utf-8")
      end
      contents.each_line do |line|
        hash = self.parse_dotstrings_line(line)
        strings.merge!(hash) if hash
      end

      strings
    end

  end
end
