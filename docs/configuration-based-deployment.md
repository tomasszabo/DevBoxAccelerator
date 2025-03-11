# Configuration-based Deployment

This landing zone accelerator uses JSON [configuration files](#configuration-files) to define the end-to-end deployments for Dev Center and Dev Center Projects. Those files are specified as a command-line parameter to the corresponding script, ```deploy.sh```, orchestrating the use of the [Azure CLI](https://learn.microsoft.com/cli/azure/) to start the subscription scoped bicep deployments. For example:

```azurecli
./deploy.sh -s <subscription_id> -c config/dev-center-contoso.json
```

The bicep templates provided for each deployment can be modified for standalone use. However, structured JSON configuration files can be beneficial compared to using a set of flat parameters in terms of readability and maintainability over time. Notably, when paired with an accompanying schema file providing some guiderails and to aid in validation.

> [!NOTE]
> The initial set of [schemas](../src/schemas/) have been provided as a starting point and can be extended as needed to cover a wider set of use cases.

## Repository structure

The repo has been organized into the following top-level folders within the root [src](../src/) folder.

- [dev-center](../src/dev-center/): Files related to **Dev Center** depoyments
- [dev-project](../src/dev-project/): Files related to **Dev Center project** depoyments
- [schemas](../src/schemas/): Schemas used by the JSON configuration files
- [shared](../src/shared/): A set of bicep templates common to all deployments

The [dev-center](../src/dev-center/) and [dev-project](../src/dev-project/) folders follow a consistent structure:

- There's a script file in the root folder, ```deploy.sh```, for starting the deployment
- A ```config``` folder includes sample configuration files that can be used for testing and as a starting point
- The ```bicep``` folder contains the bicep templates used by the deployment
- Within the ```bicep``` folder, there is a ```main.bicep``` file. The ```main.bicep``` file serves as the primary template for defining the deployment of resources and modules. The individual bicep modules are organized within a ```modules``` subfolder within the ```bicep``` folder

## Configuration files

The JSON configuration files follow the same general structure. At the top-level, they define some global deployment parameters. For example, subscriptionId and resourceGroup values along with the schema file it uses. They will then define the deployment based on the guiderails provided by the schema. For example:

```json
{
    "$schema": "../../schemas/dev-project.schema.json",
    "name": "contoso-dev-project",
    "resourceGroup": "rg-contoso-dev-project",
    "devCenterId": "<dev_center_resource_id>",
    "settings": {
        ...
    },
    "features": {
        "devBox": {
            "pools": [
                ...
            ]
        }
    }
}
```
