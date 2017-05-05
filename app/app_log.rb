require 'logger'

APP_LOG = Logger.new STDOUT

def cli_colored_text(color_code, text)
  "\e[#{color_code}#{text}\e[0m"
end

module AvxLog
  def error(text)
    APP_LOG.error(cli_colored_text("1;31m", text))
  end

  def AvxLog.warn(text)
    APP_LOG.warn(cli_colored_text("1;33m", text))
  end

  def info(text)
    APP_LOG.info(cli_colored_text("1;32m", text))
  end
end
