resource "aws_kms_key" "parameter_key" {
  provider = aws.oregon
  description             = "KMS Key for Parameter Store"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_ssm_parameter" "jenkins_private_key_oregon" {
  provider = aws.oregon
  name        = "/devops-tools/jenkins/id_rsa"
  description = "Secure Private SSH key for jenkins"
  type        = "SecureString"
  value       = tls_private_key.example.private_key_pem 
  key_id = aws_kms_key.parameter_key.key_id  
}
resource "aws_ssm_parameter" "jenkins_public_key_oregon" {
  provider = aws.oregon
  name        = "/devops-tools/jenkins/id_rsa.pub"
  description = "Secure Public SSH key for jenkins"
  type        = "SecureString"
  value       = tls_private_key.example.public_key_openssh 
  key_id = aws_kms_key.parameter_key.key_id  
}