#
# Minitest for NameServer class
#
# Copyright (c) 2014-2015 Cisco and/or its affiliates.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require File.expand_path('../ciscotest', __FILE__)
require File.expand_path('../../lib/cisco_node_utils/name_server', __FILE__)

# TestNameServer - Minitest for NameServer node utility.
class TestNameServer < CiscoTestCase
  def setup
    # setup runs at the beginning of each test
    super
    no_nameserver_google
  end

  def teardown
    # teardown runs at the end of each test
    no_nameserver_google
    super
  end

  def no_nameserver_google
    # Turn the feature off for a clean test.
    @device.cmd('conf t ; no ip name-server 8.8.8.8 ; end')
    @device.cmd('conf t ; no ip name-server 2001:4860:4860::8888 ; end')
    # Flush the cache since we've modified the device outside of
    # the node_utils APIs
    node.cache_flush
  end

  # TESTS

  def test_nameserver_create_destroy_single_ipv4
    id = '8.8.8.8'
    refute_includes(Cisco::NameServer.nameservers, id)

    ns = Cisco::NameServer.new(id)
    assert_includes(Cisco::NameServer.nameservers, id)
    assert_equal(Cisco::NameServer.nameservers[id], ns)

    ns.destroy
    refute_includes(Cisco::NameServer.nameservers, id)
  end

  def test_nameserver_create_destroy_single_ipv6
    id = '2001:4860:4860::8888'
    refute_includes(Cisco::NameServer.nameservers, id)

    ns = Cisco::NameServer.new(id)
    assert_includes(Cisco::NameServer.nameservers, id)
    assert_equal(Cisco::NameServer.nameservers[id], ns)

    ns.destroy
    refute_includes(Cisco::NameServer.nameservers, id)
  end

  def test_router_create_destroy_multiple
    id1 = '8.8.8.8'
    id2 = '2001:4860:4860::8888'
    refute_includes(Cisco::NameServer.nameservers, id1)
    refute_includes(Cisco::NameServer.nameservers, id2)

    ns1 = Cisco::NameServer.new(id1)
    ns2 = Cisco::NameServer.new(id2)
    assert_includes(Cisco::NameServer.nameservers, id1)
    assert_includes(Cisco::NameServer.nameservers, id2)
    assert_equal(Cisco::NameServer.nameservers[id1], ns1)
    assert_equal(Cisco::NameServer.nameservers[id2], ns2)

    ns1.destroy
    ns2.destroy
    refute_includes(Cisco::NameServer.nameservers, id1)
    refute_includes(Cisco::NameServer.nameservers, id2)
  end
end
