resource "aws_codepipeline" "codepipeline" {
  name     = var.codepipelinename
  role_arn = data.aws_arn.codepipelinearn.arn

  artifact_store {
    location = data.aws_s3_bucket.codepipeline_bucket_object.bucket
    type     = "S3"

    # encryption_key {
    #   id   = data.aws_kms_alias.s3kmskey.arn
    #   type = "KMS"
    # }
  }

  stage {
    name = "Source"

    action {
      name             = var.source_bucket_name
      category         = "Source"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      output_artifacts = ["SourceS3Output"]

      configuration = {
        S3Bucket = var.S3_bucket_name
        S3ObjectKey = var.S3ObjectKey
        PollForSourceChanges = var.pollchanges
      }
      run_order = 1
    }

    action {
      name             = var.ECRSource
      category         = "Source"
      owner            = "AWS"
      provider         = "ECR"
      version          = "1"
      output_artifacts = ["SourceECROutput"]

      configuration = {
        ImageTag = var.imagetag
        RepositoryName = var.Reponame
      }
      run_order = 1
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "BucketSource"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      input_artifacts = ["SourceS3Output", "SourceECROutput"]
      version         = "1"

      configuration = {
        ApplicationName     = var.appname
        DeploymentGroupName   = var.deployname
        AppSpecTemplatePath = var.templatepath
        AppSpecTemplateArtifact      = "SourceS3Output"
        TaskDefinitionTemplatePath   = var.tkdefpath
        TaskDefinitionTemplateArtifact = "SourceS3Output"
        Image1ArtifactName = "SourceECROutput"
        Image1ContainerName = "IMAGE1_NAME"
      }
      run_order = 1
    }
  }
}

data "aws_arn" "codepipelinearn" {
  arn = "arn:aws:iam::847370586410:role/service-role/AWSCodePipelineServiceRole-us-east-1-testappapcodedeplypipeline"
}
 
data "aws_s3_bucket" "codepipeline_bucket_object" {
  bucket = "jd-ecs-azure-bucket"
  key = "artifact.zip"
}


# resource "aws_codestarconnections_connection" "example" {
#   name          = "example-connection"
#   provider_type = "GitHub"
# }

# resource "aws_s3_bucket" "codepipeline_bucket" {
#   bucket = "test-bucket"
# }

# resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
#   bucket = aws_s3_bucket.codepipeline_bucket.id
#   acl    = "private"
# }

# resource "aws_iam_role" "codepipeline_role" {
#   name = "test-role"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "codepipeline.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_role_policy" "codepipeline_policy" {
#   name = "codepipeline_policy"
#   role = aws_iam_role.codepipeline_role.id

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect":"Allow",
#       "Action": [
#         "s3:GetObject",
#         "s3:GetObjectVersion",
#         "s3:GetBucketVersioning",
#         "s3:PutObjectAcl",
#         "s3:PutObject"
#       ],
#       "Resource": [
#         "${aws_s3_bucket.codepipeline_bucket.arn}",
#         "${aws_s3_bucket.codepipeline_bucket.arn}/*"
#       ]
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "codestar-connections:UseConnection"
#       ],
#       "Resource": "${aws_codestarconnections_connection.example.arn}"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "codebuild:BatchGetBuilds",
#         "codebuild:StartBuild"
#       ],
#       "Resource": "*"
#     }
#   ]
# }
# EOF
# }

# data "aws_kms_alias" "s3kmskey" {
#   name = "alias/myKmsKey"
# }