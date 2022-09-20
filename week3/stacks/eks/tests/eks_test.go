package tests

import (
	"errors"
	"fmt"
	"github.com/gruntwork-io/terratest/modules/k8s"
	"os"
	"testing"
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
	// WARNING - this updates the kubectl context for the whole machine, but is okay for tests running in containers
	// for one cluster
	UpdateKubeConfig(t, clusterName, clusterRole)

	t.Run("ExampleTestCanIGetAllNodes", func(t *testing.T) {
		options := k8s.NewKubectlOptions("", "", namespace)
		k8s.GetNodes(t, options)
	})
	t.Run("ClusterAndAllNodesAreHealthy", func(t *testing.T) {
		// Todo - use terratest's K8s module to check if all nodes are healthy.
		// Todo - Consider - is this test useful ?
		t.Error(errors.New("Test unimplemented"))
	})

	t.Run("TestEKSCanBeAdministeredByClusterAdminRole", func(t *testing.T) {
		// With the understanding that clusterAdminRoles should be able to create and delete namespace we can
		// simulate that behaviour
		// Todo - Test if can create a random namespace
		// Todo - Cleanup/Delete created namespace
		t.Error(errors.New("Test unimplemented"))
	})

	t.Run("ShouldBeAbleToCreatePodInApplicationNamespace", func(t *testing.T) {
		// Todo - Create a sample Pod using the ./pod.yml spec provided
		// Todo - Ensure Pod can spin up healthy
		// Todo - Clean up Pod after test
		t.Error(errors.New("Test unimplemented"))
	})

	t.Run("PodsShouldBeAbleToTalkToPublicEndpoints", func(t *testing.T) {
		// Todo - Create a sample Pod using the ./pod.yml spec provided
		// Todo - Ensure Pod can spin up healthy
		// Todo - Using kubectle exec and curl(installed in pod image) check if pod can reach google.com
		// Todo - Clean up Pod after test
		t.Error(errors.New("Test unimplemented"))
	})
	// Solutions at: https://github.com/Thoughtworks-SEA-Capability/infra-training-ref-infra/blob/1cb098965df1e6c8649de59020b5eb96285e414a/week3/stacks/eks/tests/eks_test.go
}
