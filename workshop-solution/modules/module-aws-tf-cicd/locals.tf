# locals {
#   all_codecommit_repos =
# }

# locals {
#   # Create a new local variable by flattening the complex type given in the variable "codebuild_projects"
#   flatten_codebuild_project_data = flatten([
#     for this_project in keys(var.codebuild_projects) : [
#       for source in var.codebuild_projects[this_project].source_location : {
#         project_name    = var.codebuild_projects[this_project].project_name
#         source_location = source
#       }
#     ]
#   ])

#   codebuild_projects_and_their_source_locations = {
#     for s in local.flatten_codebuild_project_data : format("%s_%s", s.project_name, s.source_location) => s
#   }

# }

# locals {
#   # Create a new local variable by flattening the complex type given in the variable "sso_users"
#   flatten_user_data = flatten([
#     for this_user in keys(var.sso_users) : [
#       for group in var.sso_users[this_user].group_membership : {
#         user_name  = var.sso_users[this_user].user_name
#         group_name = group
#       }
#     ]
#   ])

#   users_and_their_groups = {
#     for s in local.flatten_user_data : format("%s_%s", s.user_name, s.group_name) => s
#   }

# }
