package tests

import (
	"io/ioutil"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/k8s"
)

var clusterContext string

// TestClusterRDSIntegration is a quick and dirty but effective test that validates if a test pod can reach and log into the RDS.
// This test relies on the k8s config and context to be updated correctly externally to the test.
func TestClusterRDSIntegration(t *testing.T) {

	// namespace is hardcoded as a sort of convention between the underlying infra and the application layer.
	namespace := "application"

	// relies on the kube-config being at $HOME/.kube/config
	// relies on the current-context set to the appropriate cluster
	options := k8s.NewKubectlOptions("", "", namespace)

	// create test pod
	podYmlBytes, err := ioutil.ReadFile("./pod.yml")
	if err != nil {
		t.Error(err)
	}

	k8s.KubectlApplyFromString(t, options, string(podYmlBytes))
	defer k8s.KubectlDeleteFromString(t, options, string(podYmlBytes))
	k8s.WaitUntilPodAvailable(t, options, "test-pod", 15, 3*time.Second)

	// fire test command from test pod
	// this will test if the test pod can reach the RDS DB at the given endpoint and port
	// it will test if the test pod can log into the RDS DB with the given username and password
	k8s.RunKubectl(t, options, []string{"exec", "test-pod", "--", "sh", "-c", "PGPASSWORD=$db_password psql -h $db_endpoint -d postgres -U $db_username"}...)
}

func TestClusterRDSIntegration2(t *testing.T) {

	// namespace is hardcoded as a sort of convention between the underlying infra and the application layer.
	namespace := "workload"

	// relies on the kube-config being at $HOME/.kube/config
	// relies on the current-context set to the appropriate cluster
	options := k8s.NewKubectlOptions("", "", namespace)

	// create test pod
	podYmlBytes, err := ioutil.ReadFile("./pod.yml")
	if err != nil {
		t.Error(err)
	}

	k8s.KubectlApplyFromString(t, options, string(podYmlBytes))
	defer k8s.KubectlDeleteFromString(t, options, string(podYmlBytes))
	k8s.WaitUntilPodAvailable(t, options, "test-pod", 15, 3*time.Second)

	// fire test command from test pod
	// this will test if the test pod can reach the RDS DB at the given endpoint and port
	// it will test if the test pod can log into the RDS DB with the given username and password
	k8s.RunKubectl(t, options, []string{"exec", "test-pod", "--", "sh", "-c", "PGPASSWORD=$db_password psql -h $db_endpoint -d postgres -U $db_username"}...)
}
