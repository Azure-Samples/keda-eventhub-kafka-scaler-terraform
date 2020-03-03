# microservices-with-keda

## Prerequisites

We will be deploying to Azure, so you will need an Azure account. If you don't have an account,
[sign up for free here](https://azure.microsoft.com/en-us/free/).

This example deploys a Helm Chart from Kedacore Helm chart repository, so you
will need to [install the Helm CLI](https://docs.helm.sh/using_helm/#installing-helm) and configure it:

If you are using Helm v2:
```bash
$ helm init --client-only
$ helm repo add kedacore https://kedacore.github.io/charts
$ helm repo update
```

If you are using Helm v3:
```
$ helm repo add kedacore https://kedacore.github.io/charts
$ helm repo update