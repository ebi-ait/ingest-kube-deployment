variable "aws_profile" {
}

variable "deployment_stage" {
}

variable "aws_region" {
}

variable "account_id" {
}

variable "ops_role" {
}

variable "vpc_cidr_block" {
}

variable "node_size" {
}

variable "node_count" {
}

variable "ssh_public_key" {
}

variable "availability_zones" {
  default = [
    "us-east-1a",
    "us-east-1c",
    "us-east-1d",
  ]
  type = list(string)
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

locals {
  default_tags = {
    Owner       = "tburdett"
    Project     = "hca"
    Service     = "MAIT"
    Description = "CreatedBy Terraform"
    Environment = "${var.deployment_stage}"
  }
}


////
// general setup
//

terraform {
  backend "s3" {
  }
}

////
// Security
//

// no tags support
resource "aws_key_pair" "ingest_eks" {
    key_name = "ingest-eks-${var.deployment_stage}_key"
    public_key = var.ssh_public_key
}

////
// Network setup
//

resource "aws_vpc" "ingest_eks" {
  cidr_block = var.vpc_cidr_block

	tags = merge(
	  local.default_tags,
		{
		  "Name" = "ingest-eks-${var.deployment_stage}",
			"kubernetes.io/cluster/ingest-eks-${var.deployment_stage}"  = "shared"
    }
	)

}

resource "aws_subnet" "ingest_eks" {
  count = 2

  availability_zone = var.availability_zones[count.index]
  cidr_block        = "${cidrhost(var.vpc_cidr_block, 256 * count.index + 1)}/24"
  vpc_id            = aws_vpc.ingest_eks.id

  tags = merge(
	  local.default_tags,
		{
		  "Name" = "ingest-eks-${var.deployment_stage}",
			"kubernetes.io/cluster/ingest-eks-${var.deployment_stage}"  = "shared"
    }
	)

}

resource "aws_internet_gateway" "ingest_eks" {
  vpc_id = aws_vpc.ingest_eks.id

  tags = merge(
	  local.default_tags,
		{
		  "Name" = "ingest-eks-${var.deployment_stage}"
    }
	)
}

resource "aws_route_table" "ingest_eks" {
  vpc_id = aws_vpc.ingest_eks.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ingest_eks.id
  }

  tags = local.default_tags
}

// no tags support
resource "aws_route_table_association" "ingest_eks" {
  count = 2

  subnet_id      = aws_subnet.ingest_eks[count.index].id
  route_table_id = aws_route_table.ingest_eks.id
}

resource "aws_security_group" "ingest_eks_cluster" {
  name        = "ingest-eks-cluster-${var.deployment_stage}"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.ingest_eks.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
	  local.default_tags,
		{
		  "Name" = "ingest-eks-${var.deployment_stage}"
    }
	)
}

// no tags support
resource "aws_security_group_rule" "ingest_eks_cluster_ingress_workstation_https" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.ingest_eks_cluster.id
  to_port           = 443
  type              = "ingress"
}

////
// IAM Setup
//

resource "aws_iam_role" "ingest_eks_cluster" {
  name = "ingest-eks-cluster-${var.deployment_stage}"

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

  tags = local.default_tags

}

// no tags required for policy attachment resource type
resource "aws_iam_role_policy_attachment" "ingest_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.ingest_eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "ingest_eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.ingest_eks_cluster.name
}

////
// Cluster and Node setup
//

resource "aws_eks_cluster" "ingest_eks" {
  name     = "ingest-eks-${var.deployment_stage}"
  role_arn = aws_iam_role.ingest_eks_cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.ingest_eks_cluster.id]
    subnet_ids         = aws_subnet.ingest_eks.*.id
  }

  depends_on = [
    aws_iam_role_policy_attachment.ingest_eks_cluster_policy,
    aws_iam_role_policy_attachment.ingest_eks_service_policy,
  ]

  tags = local.default_tags

}

////
// Worker node IAM setup
//

resource "aws_iam_role" "ingest_eks_node" {
  name = "ingest-eks-node-${var.deployment_stage}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  tags = local.default_tags

}

// no tags required for policy attachment resource type
resource "aws_iam_role_policy_attachment" "ingest_eks_node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.ingest_eks_node.name
}

resource "aws_iam_role_policy_attachment" "ingest_eks_node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.ingest_eks_node.name
}

resource "aws_iam_role_policy_attachment" "ingest_eks_node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.ingest_eks_node.name
}

// no tags support
resource "aws_iam_instance_profile" "ingest_eks_node" {
  name = "terraform-eks-node-${var.deployment_stage}"
  role = aws_iam_role.ingest_eks_node.name
}

////
// Worker node security group setup
//

resource "aws_security_group" "ingest_eks_node" {
  name        = "ingest-eks-node-${var.deployment_stage}"
  description = "Security group for all nodes in the cluster"
  vpc_id      = aws_vpc.ingest_eks.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

	tags = merge(
	  local.default_tags,
		{
		  "Name" = "ingest-eks-node-${var.deployment_stage}",
			"ingest-eks-${var.deployment_stage}" = "owned"
    }
	)

}

// no tags for security group rule
resource "aws_security_group_rule" "ingest_node_ingress_self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.ingest_eks_node.id
  source_security_group_id = aws_security_group.ingest_eks_node.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingest_node_ingress_cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ingest_eks_node.id
  source_security_group_id = aws_security_group.ingest_eks_cluster.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingest_cluster_ingress_node_https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ingest_eks_cluster.id
  source_security_group_id = aws_security_group.ingest_eks_node.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingest_eks_cluster_allow_ssh" {
  description = "Allow SSH access to EKS nodes"
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ingest_eks_node.id
}

////
// Worker Node Instance Setup
//

data "aws_region" "current" {
}

data "aws_ami" "eks_worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.ingest_eks.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

locals {
  ingest-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.ingest_eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.ingest_eks.certificate_authority[0].data}' 'ingest-eks-${var.deployment_stage}' --kubelet-extra-args "--kube-reserved cpu=250m,memory=1Gi,ephemeral-storage=1Gi --system-reserved cpu=250m,memory=0.2Gi,ephemeral-storage=1Gi --eviction-hard memory.available<0.2Gi,nodefs.available<10%"
USERDATA

}

// no tags support for resource type; identify by name prefix
resource "aws_launch_configuration" "ingest_eks" {
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ingest_eks_node.name
  image_id                    = data.aws_ami.eks_worker.id
  instance_type               = var.node_size
  name_prefix                 = "ingest-eks-${var.deployment_stage}"
  security_groups             = [aws_security_group.ingest_eks_node.id]
  user_data_base64            = base64encode(local.ingest-node-userdata)
  key_name                    = aws_key_pair.ingest_eks.key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ingest_eks" {
  desired_capacity     = var.node_count
  launch_configuration = aws_launch_configuration.ingest_eks.id
  max_size             = 4
  min_size             = var.node_count
  name                 = "ingest-eks-${var.deployment_stage}"
  vpc_zone_identifier  = aws_subnet.ingest_eks.*.id

  tag {
    key                 = "Name"
    value               = "ingest-eks-${var.deployment_stage}"
    propagate_at_launch = true
  }
  
  tag {
    key                 = "kubernetes.io/cluster/ingest-eks-${var.deployment_stage}"
    value               = "owned"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = local.default_tags
    content { 
      key       = tag.key
      value     = tag.value
      propagate_at_launch = true 
    }
  }

}

////
// Config Outputs
//

locals {
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.ingest_eks.endpoint}
    certificate-authority-data: ${aws_eks_cluster.ingest_eks.certificate_authority[0].data}
  name: ingest-eks-${var.deployment_stage}
contexts:
- context:
    cluster: ingest-eks-${var.deployment_stage}
    user: ingest-eks-${var.deployment_stage}
  name: ingest-eks-${var.deployment_stage}
current-context: ingest-eks-${var.deployment_stage}
kind: Config
preferences: {}
users:
- name: ingest-eks-${var.deployment_stage}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "ingest-eks-${var.deployment_stage}"
KUBECONFIG

}

output "kubeconfig" {
  value = local.kubeconfig
}

locals {
  config_map = <<CONFIGMAPAWSAUTH
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.ingest_eks_node.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    - rolearn: arn:aws:iam::${var.account_id}:role/${var.ops_role}
      username: ops-user
      groups:
        - system:masters
CONFIGMAPAWSAUTH

}

output "config_map" {
  value = local.config_map
}

locals {
  namespace = <<NAMESPACE
apiVersion: v1
kind: Namespace
metadata:
  name: ${var.deployment_stage}-environment
  labels:
    name: ${var.deployment_stage}-environment
NAMESPACE

}

output "namespace" {
  value = local.namespace
}

locals {
  tilleraccount = <<TILLERACCOUNT
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system
TILLERACCOUNT

}

output "tilleraccount" {
  value = local.tilleraccount
}
