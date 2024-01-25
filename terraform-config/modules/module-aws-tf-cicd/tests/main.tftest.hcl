# Instructions: Create basic tests

# Configure the AWS
provider "aws" {
  region = "us-east-1"
}


# Define variables to be used in tests. You can overwrite these varibles by definig an additional variables block within the run block for your tests
variables {
  project_prefix = "this_is_a_project_prefix_and_it_is_way_too_long_and_will_cause_a_failure"

}

# - Unit Tests -
run "input_validation" {
  command = plan

  # Invalid values
  variables {
    # app name that is longer than 40 characters
    project_prefix = "this_is_a_project_prefix_and_it_is_way_too_long_and_will_cause_a_failure_and_variable_changed"

  }
  # Check for intentional failure of defined variables
  expect_failures = [
    project_prefix,

  ]
}
