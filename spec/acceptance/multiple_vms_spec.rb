# This tests Skytap-specific edge cases.
shared_examples "provider/basic" do |provider, options|
  if !options[:box]
    raise ArgumentError,
      "box option must be specified for provider: #{provider}"
  end

  include_context "acceptance"

  before do
    assert_execute("vagrant", "box", "add", "box", options[:box])
    assert_execute("vagrant", "init", "box")
  end

  after do
    # Just always do this just in case
    execute("vagrant", "destroy", "--force", log: false)
  end

  def assert_running(vm_name)
    result = execute("vagrant", "ssh", vm_name, "-c", "echo foo")
    expect(result).to exit_with(0)
    expect(result.stdout).to match(/foo\n$/)
  end

  def assert_not_running
    result = execute("vagrant", "ssh", "-c", "echo foo")
    expect(result).to exit_with(1)
  end

  # ENG-22256
  context "after an up with four vms" do
    before do
      # need different box with 4 vms (use same source vm)
      assert_execute("vagrant", "up", "--provider=#{provider}")
    end

    after do
      assert_execute("vagrant", "destroy", "--force")
    end

    it "can manage machine lifecycle" do
      status("Test: machine is running after up")
      # loop over vms
      assert_running #(vm_name)
    end
  end

  context "after an up with two vms" do
    before do
      # need different box with 4 vms (use same source vm)
      # can we do vagrant up again, specifying two vms by name?
      assert_execute("vagrant", "up", "--provider=#{provider}")
    end

    after do
      assert_execute("vagrant", "destroy", "--force")
    end

    it "has two vms in the same Skytap environment" do
      status("Test: both vms in same environment")
      # loop over vms
      # Verify by looking for .vagrant/environment, fetching
      # that configuration, and verifying that the VM ids
      # belong to that environment
    end
  end

end
