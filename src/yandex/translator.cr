require "http"
require "json"
require "uri"

module Yandex
  class Translator
    BASE_URL = "https://translate.yandex.net/api/v1.5/tr.json"

    @@api_key = ""

    def initialize(api_key)
      @@api_key = api_key
    end

    def langs
      langs = visit("/getLangs")
      langs ? langs.as_h["dirs"] : nil
    end
    
    def detect(text)
      lang = visit("/detect", {"text" => text})
      lang ? lang.as_h["lang"] : nil
    end

    def translate(text, *lang)
      if lang.last.is_a?(Hash)
        lang = leng_params(lang.last)
      end

      options = { text: text, lang: lang}

      response = visit("/translate", options)
      if response
        result = response.as_h["text"].as_a
        result.size == 1 ? result.first : result
      end
    end

    def visit(address, options = {} of String => String)
      uri = URI.encode("#{BASE_URL}#{address}?key=#{@@api_key}&#{params(options)}")
      response = HTTP::Client.post(uri,
                                   headers: HTTP::Headers{"Content-Type" => "application/json; charset=utf-8"})
      check_errors(response)
      JSON.parse(response.body)
    end

    private def check_errors(response)
      if response.status_code && response.status_code != 200
        raise Exception.new(response.body)
      end
    end

    private def params(options)
      options.map{|k,v| "#{k.to_s}=#{v.to_s}"}.join('&').to_s
    end

    private def leng_params(options)
      options.map{|k,v| "#{k.to_s}-#{v.to_s}"}.join('&')
    end

    private def encode(string : String, *args)
      String.build { |io| encode(string, io) }
    end
  end
end

