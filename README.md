Where in the World Chart
========================

This Helm chart will deploy WITW to Kubernetes

Requirements
============

The main thing you'll need is a Kubernetes cluster. There are two recommended approaches:

1. Locally with Docker for Mac Kubernetes
2. GKE on Google Cloud

You'll also need a few secrets to get it set up:

1. Google OAuth Credentials

> Note: For the redirect url it's recommended to use http://localhost:8000/complete/google-oauth2/ for testing.
 For production you can set this to you domain name which can point to the ingress loadbalancer IP

2. Google Maps API Key

These can be created in the Google Cloud console.

Once you have these, create your Kubernetes secrets:


> **Warning**
> You must create these secrets or the chart will not deploy. Ensure they are in the same namespace
```
kubectl create secret generic credentials --from-literal=mapsKey=<secret> --from-literal=oauthKey=<secret> --from-literal=oauthSecret=<secret>
```

Installing the Helm Chart
=========================

Run Helm install with your API keys passed in.

```
helm upgrade --install witw oci://registry-1.docker.io/frankh/witw --wait
```

> Note: For production, also set the DNS entry for your chosen domain name! `--set ingress.hosts[0].host=https://whereintheworld.app`

> Note: The first install will take a while, it might even time out - don't worry! It's just downloading the city data, after 5-10mins it should be good to go

Installing to a local cluster
=============================

To enable Kubernetes in Docker for Mac follow the instructions here: https://docs.docker.com/desktop/kubernetes/

Once you have deployed the chart the easiest way to access it is to port-forward:

```
kubectl port-forward service/witw 8000:http
```

Then open http://localhost:8000 in the browser and away you go!

Installing to GKE
=================

You'll need to create a GKE project with a Kubernetes cluster - see instructions on spinning up the cluster here: https://z2jh.jupyter.org/en/stable/kubernetes/google/step-zero-gcp.html

Once you have the cluster, set kubectl to use the credentials with

```
gcloud container clusters get-credentials witw --region europe-west2
```

> Note: You may need to install the `gke-gcloud-auth-plugin` plugin with `gcloud components install gke-gcloud-auth-plugin`

Once you have installed the Helm chart a Loadbalancer will be provisioned, this can take a few minutes

You will need to update your DNS entry to point the ingress IP, you can find this using

```
kubectl get ingress witw -o jsonpath="{.status.loadBalancer.ingress[0].ip}"
```

