#
# Fluent
#
# Copyright (C) 2011 FURUHASHI Sadayuki
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#
module Fluent


class TestOutput < Output
  Plugin.register_output('test', self)

  def initialize
    @emits = []
    @name = nil
  end

  attr_reader :emits, :name

  def events
    all = []
    @emits.each {|tag,events| all.concat events }
    all
  end

  def records
    @emits.map {|tag,events|
      events.map {|event| event.record }
    }.flatten
  end

  def configure(conf)
    if name = conf['name']
      @name = name
    end
  end

  def start
  end

  def shutdown
  end

  def emit(tag, es, chain)
    chain.next

    events = es.to_a

    @emits << [tag, events]
  end
end


end