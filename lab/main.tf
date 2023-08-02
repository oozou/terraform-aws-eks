locals {
  additional_cluster_role = [
    {
      name = "manual-kbank-dev-dafund-cicd-clusterrole"
      rules = [
        { # Workloads
          apiGroups = ["*"]
          resources = ["pods", "deployments", "replicasets"]
          verbs     = ["get", "list", "watch", "create", "update", "delete", "patch"]
        },
        { # Config
          apiGroups = ["*"]
          resources = ["configmaps", "secrets", "horizontalpodautoscalers"]
          verbs     = ["get", "list", "watch", "create", "update", "delete", "patch"]
        },
        { # Network
          apiGroups = ["*"]
          resources = ["services", "ingresses"]
          verbs     = ["get", "list", "watch", "create", "update", "delete", "patch"]
        },
        { # CRD
          apiGroups = ["*"]
          resources = ["secretproviderclasses", "secrets-store"]
          verbs     = ["get", "list", "watch", "create", "update", "delete", "patch"]
        },
        { # Others
          apiGroups = ["*"]
          resources = ["namespaces", "serviceaccounts"]
          verbs     = ["get", "list", "watch", "create", "update", "delete", "patch"]
        }
      ]
    }
  ]
  additional_cluster_role_binding = [
    {
      name = "bdd"
      subjects = [
        {
          kind     = "User"
          name     = "manual-kbank-dev-dafund-cicd-role"
          apiGroup = "rbac.authorization.k8s.io"
        },
        {
          kind     = "User"
          name     = "manual-kbank-dev-dafund-cicd-role-x"
          apiGroup = "rbac.authorization.k8s.io"
        }
      ]
      roleRef = {
        apiGroup = "rbac.authorization.k8s.iox"
        kind     = "ClusterRole"
        name     = "manual-kbank-dev-dafund-cicd-clusterrole"
      }
    }
  ]
}

data "template_file" "eks_manifest" {
  template = file("${path.module}/eks-manifest-file.yml")
  vars = {
    additional_cluster_role         = <<EOT
%{for cluster_role in local.additional_cluster_role~}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: ${cluster_role.name}
rules:
  %{for rule in cluster_role.rules}
  - apiGroups: ${jsonencode(rule.apiGroups)}
    resources: ${jsonencode(rule.resources)}
    verbs: ${jsonencode(rule.verbs)}
  %{~endfor~}
%{endfor~}
EOT
    additional_cluster_role_binding = <<EOT
%{for cluster_role_binding in local.additional_cluster_role_binding~}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: ${cluster_role_binding.name}
subjects:
  %{for subject in cluster_role_binding.subjects}
  - kind: ${jsonencode(subject.kind)}
    name: ${jsonencode(subject.name)}
    apiGroup: ${jsonencode(subject.apiGroup)}
  %{~endfor~}
roleRef:
  apiGroup: ${cluster_role_binding.roleRef.apiGroup}
  kind: ${cluster_role_binding.roleRef.kind}
  name: ${cluster_role_binding.roleRef.name}
%{endfor~}
EOT
  }
}

output "debug" {
  value = data.template_file.eks_manifest.rendered
}
