# Overview

Provisions the MC UI, including optional external and/or internal HTTP load balancers

# Pre-work

1. Obtain cluster credentials

```
gcloud container clusters get-credentials $GKECLUSTER \
--region $REGION \
--project $PROJECT_ID
```

2. Create new GKE namespace

```
kubectl create namespace mde-ui
```

# Installation

1. Provide variable values

> **Warning**
> We do not recommend setting `externalHttpLoadBalancer` to `true`, since the MDE UI does not feature user authentication.

> **Note**
> If you set `internalHttpLoadBalancer` to `true`, the load balancer is not deployed with an SSL certificate. To provide an SSL certificate, follow [these](https://cloud.google.com/kubernetes-engine/docs/how-to/internal-load-balance-ingress#https_between_client_and_load_balancer) instructions to create a regional self-managed SSL certificate, and set `internalHttpLoadBalancer.certificateName` to the name of the certificate you created.

2. Install chart

```
helm install mde-ui . \
--namespace mde-ui \
```

2. Update A record in DNS with the external HTTP load balancer IP to finish provisioning SSL certificate

> **Note**
> If you set `externalHttpLoadBalancer` to `true`, GKE automatically initiates the provisioning of a Google-managed SSL certificate for the provided domain. However, to complete the provisioning process, you need to set the A record of the domain to the external IP address of the external load balancer that is created by this Helm chart. Once the DNS is updated, the SSL certificate provisioning process may take up to an hour.
