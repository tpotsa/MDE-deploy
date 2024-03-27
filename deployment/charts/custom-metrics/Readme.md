# Overview

Provisions the CustomMetricAdapter, including optional external and/or internal HTTP load balancers

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

1. Install chart

```
helm install custommetricadapter . \
--namespace custommetricadapter \
```
