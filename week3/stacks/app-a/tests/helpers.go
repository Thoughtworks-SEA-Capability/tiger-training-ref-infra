package tests

import (
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ssm"
	"github.com/aws/aws-sdk-go/service/ssm/ssmiface"
	"log"
	"os/exec"
	"testing"
)

type parameterStoreClient struct {
	svc ssmiface.SSMAPI
}

func NewParameterStoreClient() *parameterStoreClient {
	sess := session.Must(session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,
	}))
	return &parameterStoreClient{
		ssm.New(sess),
	}
}

func (pClient *parameterStoreClient) GetParameterValue(name string) (value string, err error) {
	results, err := pClient.svc.GetParameter(&ssm.GetParameterInput{
		Name: &name,
	})
	if err != nil {
		return "", err
	}
	return *results.Parameter.Value, nil
}

func UpdateKubeConfig(t *testing.T, clusterName string, clusterRole string) {
	cmd := exec.Command("aws", "eks", "update-kubeconfig", "--region", "ap-southeast-1", "--name", clusterName, "--role-arn", clusterRole)
	log.Println(cmd.String())
	output, err := cmd.Output()
	if err != nil {
		t.Fatal(err)
	}
	log.Println(string(output))
}
