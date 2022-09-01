variable "region" {
  type = string
  description = "Name of Region"
}
variable "codepipelinename" {
  type        = string
  description = "Name of CodePipeline"
}

variable  "source_bucket_name" {
  type = string
  description = "Name of Source Bucket"
}

variable "S3_bucket_name" {
  type = string
  description = "Name of Bucket"
}

variable "S3ObjectKey" {
  type = string
  description = "Name of Artifact"
}

variable "pollchanges" {
  type = bool
  description = "Poll For Source Changes"
}

variable "ECRSource" {
  type = string
  description = "ECR Source"
}

variable "imagetag" {
  type = string
  description = "Image Tag used in reponame"
}

variable "Reponame" {
  type = string
  description = "Repo Name"
}

variable "appname" {
  type = string
  description = "Name of Application Name"
}

variable "deployname" {
  type = string
  description = "Name of Deployment Name"
}

variable "templatepath" {
  type = string
  description = "Path of Template Path"
}

variable "tkdefpath" {
  type = string
  description = "Path of TaskDefinition Path"
}


