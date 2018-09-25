# frozen_string_literal: true

# use awesome_print in console default
require "awesome_print"
Pry.config.print = proc { |output, value| Pry::Helpers::BaseHelpers.stagger_output("=> #{value.ai}", output) }
