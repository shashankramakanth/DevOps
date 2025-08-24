resource "tls_private_key" "tls_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "devops-kp" {
  key_name = "devops-kp"
  public_key = tls_private_key.tls_key.public_key_openssh
}

resource "local_file" "private_key_pem" {
    content = tls_private_key.tls_key.private_key_pem
    filename = "/home/bob/devops-kp.pem"
    file_permission = "0600"
}