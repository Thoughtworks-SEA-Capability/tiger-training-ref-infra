package tests

import (
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestNetworkingStack(t *testing.T) {
	region := "ap-southeast-1"
	_, err := aws.NewAuthenticatedSession(region)
	if err != nil {
		t.Fatal(err)
	}

	t.Run("TestAccountIdEqualTWAccount", func(t *testing.T) {
		accountId := aws.GetAccountId(t)
		assert.Equal(t, accountId, "911960542707")
	})

	t.Run("TestGetVPC", func(t *testing.T) {
		aws.GetVpcById(t, "vpc-0ae9e33a5c42e3c86", region)
	})
}
