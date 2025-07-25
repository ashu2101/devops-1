resource "null_resource" "hello" {
  provisioner "local-exec" {
    command = "chmod +x execution.sh ; ./execution.sh" # Shell command / Scripts to execute
    # command = "echo Hello, Terraform! > abc.txt" # Shell command / Scripts to execute
  }
}
