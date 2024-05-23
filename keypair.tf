resource "aws_key_pair" "k8s_kubeadmn" {
  key_name   = "k8s_kubeadmn"
  public_key = file("k8s_kubeadmn.pub") #no need to give the full path because we are in the same working directory
  #to get the public_key content, let first generate public and private key on the command line in the same working directory with the cmd:ssh-keygen -f k8s_kubeadmn;this command created 2 keys, 1 private(k8s_kubeadmn) and 1 pub(k8s_kubeadmn.pub)

}