# Copyright (c) 2014-2016 Skytap, Inc.
#
# The MIT License (MIT)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

require 'log4r'
require 'vagrant-skytap/api/vm'
require_relative 'action_helpers'

module VagrantPlugins
  module Skytap
    module Action
      class DeleteVm
        include ActionHelpers

        # Deletes Skytap VM and removes it from the global machine index.
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new("vagrant_skytap::action::delete_vm")
        end

        def call(env)
          environment = env[:environment]
          if vm = current_vm(env)
            vm.delete
            environment.wait_until_ready
          end
          env[:machine].id = nil

          @app.call(env)
        end
      end
    end
  end
end
