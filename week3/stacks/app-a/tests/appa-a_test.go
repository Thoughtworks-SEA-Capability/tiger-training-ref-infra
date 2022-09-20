package tests

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/k8s"
	"io/ioutil"
	"os"
	"testing"
	"time"
)

var clusterContext string

// TestClusterRDSIntegration is a quick and dirty but effective test that validates if a test pod can reach and log into the RDS.
// This test relies on the k8s config and context to be updated correctly externally to the test.
func TestAppAStack(t *testing.T) {
	TeamName := os.Getenv("TEAM_NAME")
	Environment := os.Getenv("ENVIRONMENT")
	// namespace is hardcoded as a sort of convention between the underlying infra and the application layer.
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

	t.Run("AppShouldBeAbleToConnectWithRDS", func(t *testing.T) {
		// Create test fixtures
		options := k8s.NewKubectlOptions("", "", namespace)
		podYmlBytes, err := ioutil.ReadFile("./pod.yml")
		if err != nil {
			t.Error(err)
		}
		k8s.KubectlApplyFromString(t, options, string(podYmlBytes))
		defer k8s.KubectlDeleteFromString(t, options, string(podYmlBytes))
		k8s.WaitUntilPodAvailable(t, options, "test-app-pod", 15, 3*time.Second)

		// fire test command from test pod
		// this will test if the test pod can reach the RDS DB at the given endpoint and port
		// it will test if the test pod can log into the RDS DB with the given username and password
		k8s.RunKubectl(t, options, []string{"exec", "test-app-pod", "--", "sh", "-c", "PGPASSWORD=$db_password psql -h $db_endpoint -d postgres -U $db_username"}...)
	})
}
