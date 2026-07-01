# Unit Tests for tf-atom-security-group-aws
#
# These tests use a mock AWS provider — no real AWS calls are made.
# Run with:         terraform test -test-directory=tests/unit
# Run verbose:      terraform test -test-directory=tests/unit -verbose
# Run specific:     terraform test -test-directory=tests/unit -run "creates_when_enabled"
#
# NOTE: Under a mock provider, computed attributes (security group id/arn) are
# UNKNOWN at plan time, so assertions target plan-KNOWN values only:
#   - output.enabled (derived from module.this.enabled)
#   - the resource count (length of the resource list)
#   - input pass-throughs.

mock_provider "aws" {}

variables {
  # tf-label required identity inputs
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  # module's own required inputs
  vpc_id = "vpc-0123456789abcdef0"
}

# ---------------------------------------------------------------------------
# Test: Module creates the security group when enabled (default)
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = output.enabled == true
    error_message = "output.enabled should be true when the module is enabled"
  }

  assert {
    condition     = length(aws_security_group.this) == 1
    error_message = "exactly one aws_security_group should be planned when enabled"
  }

  assert {
    condition     = aws_security_group.this[0].vpc_id == "vpc-0123456789abcdef0"
    error_message = "the security group must be created in the provided vpc_id"
  }
}

# ---------------------------------------------------------------------------
# Test: Module creates nothing when disabled
# ---------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = output.enabled == false
    error_message = "output.enabled should be false when the module is disabled"
  }

  assert {
    condition     = length(aws_security_group.this) == 0
    error_message = "no security group should be planned when disabled"
  }

  assert {
    condition     = output.id == null
    error_message = "output.id must be null when the module is disabled"
  }
}
