.PHONY: cluster-setup cluster-teardown cluster-start cluster-stop
CLUSTER=ha-cluster

cluster-setup:
	k3d cluster create -c simulators/k3d/$(CLUSTER).yml
cluster-start:
	k3d cluster start $(CLUSTER)
cluster-stop:
	k3d cluster stop $(CLUSTER)
cluster-teardown:
	k3d cluster delete -c simulators/k3d/$(CLUSTER).yml