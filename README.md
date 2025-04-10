# Welcome to the Microsoft Dev Center Landing Zone Accelerator (LZA)

## Overview

The purpose of this accelerator is to provide a starting point for customers looking to use Microsoft Dev Center to improve developer productivity in Azure.

The current focus is on Dev Box, with Bicep IaC samples designed to accelerate adoption and expedite the build process. However, the repository will expand over time to include support for Azure Deployment Environments and additional tooling. Various scenarios will be provided to help customers at different stages of their Dev Center journey. Anonymous customer feedback will be continuously reviewed and incorporated to refine and improve the repository as it evolves.

## Architectural Diagram

The Dev Center accelerator slots into the wider enterprise-scale landing zone architecture as seen below. Enterprise-scale is an architectural approach that leverages modular designs and reference implementations to help organizations manage and scale their Azure environments to meet their evolving business needs. This approach aligns with the [Azure roadmap](https://aka.ms/azureroadmap) and the [Cloud Adoption Framework for Azure](https://learn.microsoft.com/azure/cloud-adoption-framework/).

![DevBox High-Level Architecture](/images/devbox-enterprise-scale-architecture.png)

*Download the Visio diagram for this architecture [here](/diagrams/devbox-accelerator-diagrams.vsdx).*

The accelerator is mainly concerned with what gets deployed in the landing zone subscription highlighted by the red boxes in the picture above. It is assumed that an appropriate platform foundation is already setup which may or may not be the official [ESLZ](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/) platform foundation. This means that policies and governance should already be in place or should be setup after this implementation and are not a part of the scope this reference implementation. The policies applied to management groups in the hierarchy above the subscription will trickle down to the Dev Center Landing Zone Accelerator landing zone subscription. Having a platform foundation is not mandatory, it just enhances it. The modularized approach used in this program allows the user to pick and choose whatever portion is useful to them. You don't have to use all the resources provided by this program.

## :mag: Design Areas

### Dev Box Design Areas

If you're new to Dev Box, watch this video for a high-level overview of the architecture.

[![Dev Box overview](https://img.youtube.com/vi/qT_6bnbMtbs/0.jpg)](https://www.youtube.com/watch?v=qT_6bnbMtbs)

| Design Area|Considerations|Recommendations|
|:--------------:|:--------------:|:--------------:|
| Management |[Design Considerations](https://learn.microsoft.com/en-us/azure/dev-box/concept-dev-box-concepts#dev-center)|[Design Recommendations](https://learn.microsoft.com/en-us/azure/dev-box/concept-dev-box-role-based-access-control#dev-center-resource-group-and-project-structure)|
| Governance |[TBC]()|[Design Recommendations](https://learn.microsoft.com/en-us/azure/dev-box/concept-dev-box-deployment-guide#step-1-configure-azure-subscription)|
| Identity and Access Management|[Design Considerations](https://learn.microsoft.com/en-us/azure/dev-box/concept-dev-box-architecture#identity-services)|[Design Recommendations](https://learn.microsoft.com/en-us/azure/dev-box/concept-dev-box-role-based-access-control)|
| Network Topology and Connectivity|[Design Considerations](https://learn.microsoft.com/en-us/azure/dev-box/concept-dev-box-network-requirements)|[Design Recommendations](https://learn.microsoft.com/en-us/azure/dev-box/concept-dev-box-deployment-guide#step-2-configure-network-components)|
| Security|[TBC](TBC)|[TBC](https://learn.microsoft.com/en-us/azure/dev-box/concept-dev-box-deployment-guide#step-3-configure-security-groups-for-role-based-access-control)|
| Micrsoft Intune Integration |[Design Considerations](https://learn.microsoft.com/en-us/azure/dev-box/concept-dev-box-architecture#microsoft-intune-integration)|[Design Recommendations](https://learn.microsoft.com/en-us/azure/dev-box/concept-dev-box-deployment-guide#step-11-configure-microsoft-intune)|
| Application Management |[TBC](TBC)|[TBC](TBC)|
| Image Management |[TBC](TBC)|[TBC](TBC)|


## :rocket: Deployment Scenarios

This repo contains Dev Center reference implementations, all with supporting Infrastructure as Code artifacts. The scenarios covered are:

- :arrow_forward: [Single Region Secure Baseline Dev Box implementation](/scenarios/single-region-secure-baseline/README.md)

*More reference implementation scenarios will be added as they become available.*

## Getting Started

### Prerequisites

To deploy the reference implementations you will need the following tooling installed:

1. [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli).
1. [Bicep CLI](https://docs.microsoft.com/azure/azure-resource-manager/bicep/install)
1. [JQ](https://jqlang.org/download/)

> [!IMPORTANT]
> You must have contributor rights on the subscriptions where the [Dev Center](https://learn.microsoft.com/azure/templates/microsoft.devcenter/devcenters) and [Dev Center project](https://learn.microsoft.com/azure/templates/microsoft.devcenter/projects) resources will be deployed to. Typically, as-per the [Azure Landing Zone architecture](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-architecture), Dev Center is deployed to a platform subscription and Dev Center Projects are deployed to a separate workload/app subscription. However, you can use the same subscription for both deployments if you do not have a platform foundation in place.

### Deploying Reference Implementations

The [Dev Center](https://learn.microsoft.com/azure/templates/microsoft.devcenter/devcenters) and [Dev Center project](https://learn.microsoft.com/azure/templates/microsoft.devcenter/projects) deployments are performed separately as standalone actions in this example.

This landing zone accelerator uses a [configuration-based deployment](/docs/configuration-based-deployment.md) approach. The JSON configuration files provided are specific to each scenario (see [Deployment scenarios](#rocket-deployment-scenarios)) and are specified as command line parameters when executing the deployment scripts. The steps are otherwise consistent for all [scenarios](#rocket-deployment-scenarios).

#### Predeployment Steps

1. If you have not done so already, clone this repository.

```sh
git clone https://github.com/your-repo/devboxaccelerator.git
```

1. Change the directory to the root of the repository.

1. Create your scenario-specific configuration files for the [Dev Center](#deploy-dev-center) and [Dev Center project](#deploy-dev-project) deployments using the samples provided, named with the ```.sample``` suffix, as a starting point. You can create configuration files within the existing config folders for convenience as they should be git ignored.

1. Login to your Azure account:

    ```sh
    az login
    ```

    > [!NOTE]
    > If you have multiple tenants, consider targeting a specific tenant using the ```--tenant TENANT_ID``` option to ensure you are logging into the correct one and deploying resources within that tenant's context.

#### Deployment Steps

Ensure you have completed the requisite [predeployment steps](#predeployment-steps) before executing the [Dev Center](#deploy-dev-center) or [Dev Center project](#deploy-dev-project) deployments.

##### Deploy Dev Center

1. Change directory to the [dev-center](/src/dev-center/) folder.

1. Execute the deployment script specifying the target subscription (e.g., the platform subscription) and the Dev Center configuration file you had created for the scenario you're targeting.

    ```dotnetcli
    ./deploy.sh -s <subscription_id> -c <configuration_filepath>
    ```

1. Make note of any values written to the ```.output``` file for convenience, such as ```devCenterId```, for use with the [Dev Center project](#deploy-dev-center). This file is named after the configuration file used for the deployment.

> [!NOTE]
> You can optionally update the placeholder ```subscriptionId``` in the config with your own value to avoid the need for the ```-s``` option.

##### Deploy Dev Project

To run these steps, you will need to have a [Dev Center](#deploy-dev-center) resource deployed. You can use a Dev Center that was not deployed via the deployment script provided in this repo. However, you must ensure it is configured appropriately for the chosen [deployment scenarios](#rocket-deployment-scenarios).

> [!IMPORTANT]
> If you have not done so already, you should ensure your Dev Center project configuration file is referencing the appropriate **Resource ID** values for any existing resources it has a dependency on. For example, the ```devCenterId``` along with any networks to be connected.

1. Change directory to the [dev-project](/src/dev-project/) folder.

1. Execute the deployment script specifying the target subscription (e.g., the workload/application subscription) and the Dev Center Project configuration file you had created for the scenario you're targeting.

    ```dotnetcli
    ./deploy.sh -s <subscription_id> -c <configuration_filepath>
    ```

#### Dev Project Post-deployment

1. [Grant access to the dev box project](https://learn.microsoft.com/azure/dev-box/how-to-dev-box-user#assign-permissions-to-dev-box-users) by assigning users to the built-in ```Dev Center Dev Box User``` role.

## Give Feedback

Please leverage issues if you have any feedback or request on how we can improve on this repository.

---

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit <https://cla.opensource.microsoft.com>.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft
trademarks or logos is subject to and must follow
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.
