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
    Project     = "hca"
    Service     = "ait"
    Owner       = "tburdett"
    Env         = "${var.deployment_stage}"
    CreatedBy   = "terraform"
  }

  cluster_name =  "ingest-eks-${var.deployment_stage}"
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

  #This is very important, as it tells terraform to not mess with tags created outside of terraform
  lifecycle {
    ignore_changes = ["tags"]
  }

}

resource "aws_subnet" "ingest_eks" {
  count = 2

  availability_zone = var.availability_zones[count.index]
  cidr_block        = "${cidrhost(var.vpc_cidr_block, 256 * count.index)}/24"
  vpc_id            = aws_vpc.ingest_eks.id
  map_public_ip_on_launch = true

  tags = merge(
	  local.default_tags,
		{
		  "Name" = "ingest-eks-${var.deployment_stage}",
			"kubernetes.io/cluster/ingest-eks-${var.deployment_stage}"  = "shared"
    }
	)

  #This is very important, as it tells terraform to not mess with tags created outside of terraform
  lifecycle {
    ignore_changes = ["tags"]
  }

}

resource "aws_internet_gateway" "ingest_eks" {
  vpc_id = aws_vpc.ingest_eks.id

  tags = merge(
	  local.default_tags,
		{
		  "Name" = "ingest-eks-${var.deployment_stage}"
    }
	)

  #This is very important, as it tells terraform to not mess with tags created outside of terraform
  lifecycle {
    ignore_changes = ["tags"]
  }
}

resource "aws_route_table" "ingest_eks" {
  vpc_id = aws_vpc.ingest_eks.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ingest_eks.id
  }

  tags = local.default_tags

  #This is very important, as it tells terraform to not mess with tags created outside of terraform
  lifecycle {
    ignore_changes = ["tags"]
  }
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

  #This is very important, as it tells terraform to not mess with tags created outside of terraform
  lifecycle {
    ignore_changes = ["tags"]
  }
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
  #This is very important, as it tells terraform to not mess with tags created outside of terraform
  lifecycle {
    ignore_changes = ["tags"]
  }

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

resource "aws_iam_role" "ingest_eks_node_group" {
  name = "ingest-eks-node-group-${var.deployment_stage}"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "ingest_eks_node_group-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.ingest_eks_node_group.name
}

resource "aws_iam_role_policy_attachment" "ingest_eks_node_group-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.ingest_eks_node_group.name
}

resource "aws_iam_role_policy_attachment" "ingest_eks_node_group-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.ingest_eks_node_group.name
}

////
// Cluster setup
//
resource "aws_eks_cluster" "ingest_eks" {
  name     = local.cluster_name
  role_arn = aws_iam_role.ingest_eks_cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.ingest_eks_cluster.id]
    subnet_ids         = aws_subnet.ingest_eks.*.id
  }

  depends_on = [
    aws_iam_role_policy_attachment.ingest_eks_cluster_policy,
    aws_iam_role_policy_attachment.ingest_eks_service_policy,
    aws_cloudwatch_log_group.eks_cluster_cloudwatch
  ]

  tags = local.default_tags

  #This is very important, as it tells terraform to not mess with tags created outside of terraform
  lifecycle {
    ignore_changes = ["tags"]
  }

  enabled_cluster_log_types = ["api", "audit"]

}

resource "aws_cloudwatch_log_group" "eks_cluster_cloudwatch" {
  # The log group name format is /aws/eks/<cluster-name>/cluster
  # Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  name              = "/aws/eks/${local.cluster_name}/cluster"
  retention_in_days = 30

  # ... potentially other configuration ...
}

////
// Node Group setup
//
resource "aws_eks_node_group" "ingest_eks" {
  cluster_name    = aws_eks_cluster.ingest_eks.name
  node_group_name = "ingest-eks-${var.deployment_stage}-node-group"
  node_role_arn   = aws_iam_role.ingest_eks_node_group.arn
  subnet_ids      = aws_subnet.ingest_eks[*].id
  launch_template {
    name = aws_launch_template.ingest_eks.name
    version = "$Latest"
  }
  scaling_config {
    desired_size = var.node_count
    max_size     = 5
    min_size     = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.ingest_eks_node_group-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.ingest_eks_node_group-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.ingest_eks_node_group-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_launch_template" "ingest_eks" {
  name_prefix                 = "ingest-eks-${var.deployment_stage}"

  image_id = data.aws_ssm_parameter.eksami.value
  instance_type = var.node_size
  key_name                    = aws_key_pair.ingest_eks.key_name
  vpc_security_group_ids =  [aws_security_group.ingest_eks_node.id]

  monitoring {
    enabled = true
  }

  user_data = base64encode(local.ingest-node-userdata)

  lifecycle {
    create_before_destroy=true
  }
}

data "aws_ssm_parameter" "eksami" {
  name=format("/aws/service/eks/optimized-ami/%s/amazon-linux-2/recommended/image_id", aws_eks_cluster.ingest_eks.version)
}

locals {
  ingest-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.ingest_eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.ingest_eks.certificate_authority[0].data}' 'ingest-eks-${var.deployment_stage}' --kubelet-extra-args "--kube-reserved cpu=250m,memory=1Gi,ephemeral-storage=1Gi --system-reserved cpu=250m,memory=0.2Gi,ephemeral-storage=1Gi --eviction-hard memory.available<0.2Gi,nodefs.available<10%"
USERDATA

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
  #This is very important, as it tells terraform to not mess with tags created outside of terraform
  lifecycle {
    ignore_changes = ["tags"]
  }

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
    - rolearn: ${aws_iam_role.ingest_eks_node_group.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    - rolearn: arn:aws:iam::${var.account_id}:role/${var.ops_role}
      username: ops-user
      groups:
        - system:masters
  mapUsers: |
    - groups:
        - system:masters
      userarn: arn:aws:iam::871979166454:user/sa-ait-hca-eks-admin
      username: ops-user

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
