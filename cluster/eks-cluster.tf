# EKS Cluster Resources

resource "aws_iam_role" "gc-cluster" {
  name = "terraform-eks-gc-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "gc-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.gc-cluster.name}"
}

resource "aws_iam_role_policy_attachment" "gc-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.gc-cluster.name}"
}

resource "aws_security_group" "gc-cluster" {
  name        = "terraform-eks-gc-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${aws_vpc.gc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks-gc"
  }
}

resource "aws_security_group_rule" "gc-cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.gc-cluster.id}"
  source_security_group_id = "${aws_security_group.gc-node.id}"
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "gc-cluster-ingress-workstation-https" {
  cidr_blocks       = ["${local.workstation-external-cidr}"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.gc-cluster.id}"
  to_port           = 443
  type              = "ingress"
}

resource "aws_eks_cluster" "gc" {
  name     = "${var.cluster-name}"
  role_arn = "${aws_iam_role.gc-cluster.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.gc-cluster.id}"]
    subnet_ids         = "${aws_subnet.gc.*.id}"
  }

  depends_on = [
    "aws_iam_role_policy_attachment.gc-cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.gc-cluster-AmazonEKSServicePolicy",
  ]
}
