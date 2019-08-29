require "./yandex/translator.cr"

module Yandex
  VERSION = "0.1.0"
  raise Exception.new("Some error")
  # TODO: Put your code here
  y = Yandex::Translator.new("trnsl.1.1.20170418T084954Z.c456230e197006ed.2b34f016e9411a7b745a839ebd19519903bff340")
  puts y.langs.to_s
end
