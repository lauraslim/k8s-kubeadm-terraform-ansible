#these are the values we want terraform to print
output "master" {
  value = aws_instance.k8s_master.public_ip

}
#[*] is used here because we have multiples nodes, therfore, multiples ip that we want to be print out
output "workers" {
  value = aws_instance.k8s_workers[*].public_ip

}