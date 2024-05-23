resource "aws_security_group" "master" {
  name        = "master_sg"
  description = "master security group"


  #accept incomming traffic from anywhere, any ip address(reason why we put [0.0.0.0/0] and [::/0])
  ingress {
    description = "https"
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "http"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  #port used to access virtual machine that we created
  ingress {
    description = "ssh"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  #port open that will be used to send mail notification from our jenkins server
  ingress {
    description = "smtps"
    from_port   = 465
    protocol    = "tcp"
    to_port     = 465
    cidr_blocks = ["0.0.0.0/0"]
  }
  #these port are open because most applications are usually deployed within this range
  ingress {
    description = "custom tcp"
    from_port   = 3000
    protocol    = "tcp"
    to_port     = 10000
    cidr_blocks = ["0.0.0.0/0"]
  }
  #most companies used this port to send email notification 
  ingress {
    description = "smtp"
    from_port   = 25
    protocol    = "tcp"
    to_port     = 25
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # semantically equivalent to all ports
    cidr_blocks = ["0.0.0.0/0"]
  }


  #port to open in order to install kubernetes cluster on our ec2 instances


  #port that will be used when we set up our kubernetes cluster
  ingress {
    description      = "kubernetes API server"
    from_port        = 6443
    protocol         = "tcp"
    to_port          = 6443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

  ingress {
    description      = "etcd server client API"
    from_port        = 2379
    protocol         = "tcp"
    to_port          = 2380
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "weavenet cni tcp"
    from_port        = 6783
    protocol         = "tcp"
    to_port          = 6783
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "weavenet cni tcp"
    from_port        = 6784
    protocol         = "udp"
    to_port          = 6784
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "kubelet API, kube-scheduler,kube-controller-manager, read-only-kubelet api, kubelet-health"
    from_port        = 10248
    protocol         = "tcp"
    to_port          = 10260
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

  #for nodeport services

  ingress {
    description      = "NodePortservices"
    from_port        = 30000
    protocol         = "tcp"
    to_port          = 32767
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # semantically equivalent to all ports
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "master_sg"
  }
}

resource "aws_security_group" "workers" {
  name        = "workers_sg"
  description = "security group for workers nodes"


  #port to open for application deployment on our kubernetes cluster
  ingress {
    description      = "weavenet cni tcp"
    from_port        = 6783
    protocol         = "tcp"
    to_port          = 6783
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

  ingress {
    description      = "weavenet cni tcp"
    from_port        = 6784
    protocol         = "udp"
    to_port          = 6784
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

  ingress {
    description      = "kubelet API, kube-scheduler,kube-controller-manager, read-only-kubelet api, kubelet-health"
    from_port        = 10248
    protocol         = "tcp"
    to_port          = 10260
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

  #for nodeport services

  ingress {
    description      = "NodePortservices"
    from_port        = 30000
    protocol         = "tcp"
    to_port          = 32767
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  tags = {
    Name = "workers_sg"
  }
}