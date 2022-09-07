WEEK2-08#2022-09-07, Delete kubernetes_namespace_v1 and kubernetes_secret_v1 that use ns application
WEEK2-07#2022-09-07, Change locals application_ns_name in app-a
WEEK2-06#2022-09-07, Change locals application_ns_name in eks from "application" to "workload"
WEEK2-05#2022-09-07, Add namespace "workload" and create resources based on new namespace [Apply eks and app-a]
WEEK2-04#2022-09-07, 
- Remove the old EKS private subnet from list
- Change slice from 3 to 6
- Move states of module.vpc.aws_subnet.private and module.vpc.aws_route_table_association.private [Apply networking and eks]
WEEK2-03#2022-09-05, Reconfig EKS to use only new private subnets from 6 to 9 [Apply networking and eks]
WEEK2-02#2022-09-05, Added new subnet and expand eks private subnet from 3 to 6 subnets [Apply networking and eks]
WEEK2-01#2022-09-05, Added approval step only prod. Expect eks and app-a fail at the first time
WEEK1-01#2022-08-20, 