Location.import_cities
Skill.seed
Role.seed
user = UserService.create_admin_user('fire@kidbombay.com', 'testtest')
user = UserService.create_admin_user('blakewills525@yahoo.com', 'testtest')
user = UserService.create_admin_user('stardusts_25@yahoo.com', 'testtest')

Company.import
Badge.seed