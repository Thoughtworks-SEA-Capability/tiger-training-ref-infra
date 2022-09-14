package tests

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/k8s"
	"os"
	"testing"
	"time"
)

func TestEKSStack(t *testing.T) {
	TeamName := os.Getenv("TEAM_NAME")
	Environment := os.Getenv("ENVIRONMENT")
	const namespace = "application"

	// Setup read the cluster name and cluster IAM role from the SSM Parameter Store
	pClient := NewParameterStoreClient()
	clusterNameParameter := fmt.Sprintf("%s-%s-%s", TeamName, Environment, "eks-cluster-id")
	clusterName, err := pClient.GetParameterValue(clusterNameParameter)
	if err != nil {
		t.Fatal(err)
	}

	clusterRoleParameter := fmt.Sprintf("%s-%s-%s", TeamName, Environment, "cluster-admin-role")
	clusterRole, err := pClient.GetParameterValue(clusterRoleParameter)
	if err != nil {
		t.Fatal(err)
	}
	// WARNING - this updates the kubectl context for the whole machine
	UpdateKubeConfig(t, clusterName, clusterRole)

	t.Run("ClusterAndAllNodesAreHealthy", func(t *testing.T) {
		options := k8s.NewKubectlOptions("", "", namespace)
		k8s.AreAllNodesReady(t, options)
	})

	t.Run("TestEKSCanBeAdministeredByClusterAdminRole", func(t *testing.T) {
		// With the understanding that clusterAdminRoles should be able to create and delete namespace we can
		// simulate that behaviour
		options := k8s.NewKubectlOptions("", "", namespace)
		namespaceName := fmt.Sprintf("test-ns-%d", time.Now().Unix())
		k8s.CreateNamespace(t, options, namespaceName)
		defer k8s.DeleteNamespace(t, options, namespaceName)
	})

	t.Run("ShouldHaveRequiredNameSpace", func(t *testing.T) {
		// This is an example of a useless test - it only tests that the namespace exists, we should not expect the
		// stack to be able to apply successfully without the namespace existing, given the declarative nature of terraform
	})

	t.Run("ShouldBeAbleToCreatePodInApplicationNamespace", func(t *testing.T) {
		options := k8s.NewKubectlOptions("", "", namespace)
		k8s.KubectlApply(t, options, "./pod.yml")
		defer k8s.KubectlDelete(t, options, "./pod.yml")
		k8s.WaitUntilPodAvailable(t, options, "test-eks-pod", 15, 3*time.Second)
	})

	t.Run("PodsShouldBeAbleToTalkToPublicEndpoints", func(t *testing.T) {
		options := k8s.NewKubectlOptions("", "", namespace)
		k8s.KubectlApply(t, options, "./pod.yml")
		defer k8s.KubectlDelete(t, options, "./pod.yml")
		k8s.WaitUntilPodAvailable(t, options, "test-eks-pod", 15, 3*time.Second)

		k8s.RunKubectl(t, options, []string{"exec", "test-eks-pod", "--", "sh", "-c", "curl www.google.com"}...)

	})

}
