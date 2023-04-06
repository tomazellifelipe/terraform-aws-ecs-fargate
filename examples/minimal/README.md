# minimal
Minimal configuration for an ECS Service, with only data block and no variables.

# FAQ
Q: Why do you use a data block for the taskDefinition when it is being created already ?

A: Because if you are using ECS deploy with CodePipeline, every time a pipeline runs it will create a new revision,
this way terraform will always update to the last created one

Q: My taskDefinition keeps creating a new revision even when I have made no changes, why ?

A: It seems there is a diference between the creation in AWS and the terraform null values, for exemple
on this minimal configuration the is no `environment: []` so it is null, but AWS create with a empty list, so every run in terraform
it says there is a diference.
