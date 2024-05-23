#master node creation
resource "aws_instance" "k8s_master" {
  ami             = var.ami.master
  instance_type   = var.instance_type["master"]
  key_name        = aws_key_pair.k8s_kubeadmn.key_name #attach our key pair to our instance
  security_groups = [aws_security_group.master]
  #attach our security groups to ourcontrol plane instance

  tags = {
    Name = "k8s-master"
  }
  root_block_device {
    volume_size = 14 #storage for each instance
    volume_type = "gp2"
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(k8s_kubeadmn)
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "./master.sh"
    destination = "/home/ubuntu/master.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/master.sh ",
      "sudo sh /home/ubuntu/master.sh k8s-maste"
    ]
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i '${self.public_ip},' playbook.yml"

  }
}


#workers node creation
resource "aws_instance" "k8s_workers" {
  count           = var.workers_nodes_count
  ami             = var.ami.workers
  instance_type   = var.instance_type["workers"]
  key_name        = aws_key_pair.k8s_kubeadmn.key_name #attach our key pair to our instance
  security_groups = [aws_security_group.workers]
  #attach our security groups to ourcontrol plane instance

  tags = {
    Name = "k8s-workers-${count.index}"
  }
  depends_on = [aws_instance.k8s_master]
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(k8s_kubeadmn)
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "./worker.sh"
    destination = "/home/ubuntu/worker.sh"
  }
  provisioner "file" {
    source      = "./join-command.sh"
    destination = "/home/ubuntu/join-command.sh"

  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/worker.sh ",
      "sudo sh /home/ubuntu/worker.sh k8s-work-${count.index}",
      "sudo sh /home/ubuntu/join-command.sh"
    ]
  }


}
