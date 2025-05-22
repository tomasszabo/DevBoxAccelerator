# Dev Box Image Customization Guidance for Organizations

## Introduction

This document is intended for **Dev Center Admins** and **Dev Center Project Admins (Team Leads)** who aim to provision Dev Boxes with pre-installed software and organizational policies tailored to their project needs.

There are multiple approaches to image customization within the Dev Box environment:<br/>

- **Full Custom Image** : A complete virtual machine image built outside the Dev Box environment using services like Azure Image Builder, published to an Azure Compute Gallery. This is often referred to as a *"one-size-fits-all"* golden image.
- **Baseline Image with Team Customizations**: A foundational image created externally (e.g., via Azure Image Builder) and published to an Image Gallery, supplemented with additional configurations using the Dev Box **Team Customizations** feature, allowing flexible, persona-based setups. This approach delegates some customization responsibilities (the ones not in the baseline image) from the central IT team to project administrators, empowering them to tailor configurations to their specific project needs
- **Team Customizations Only** : No external image creation is required. All configurations are executed within the Dev Box service using the **Team Customizations** feature, allowing flexible, persona-based setups. This approach delegates customization responsibilities from the central IT team to project administrators, empowering them to tailor configurations to their specific project needs.

## Planning Your Custom Image

### Determining the customization approach to choose and developer personas

The following decision tree can help you pick which approach to use:<br/><br/>
![Image Customization decision tree](./images/Dev%20Box%20LZA%20Image%20Decision%20Tree.png)

When implementing team customizations, it is recommended to define the developer or user personas who will be using the Dev Boxes. This enables targeted configurations tailored to each persona’s specific needs. For example, if your team includes distinct roles such as backend developers, frontend developers, AI engineers, data scientists, and QA engineers, each group may require different tools and environments. To avoid unnecessary bloat and ensure efficiency, we recommend creating separate customizations for each persona.

### Selecting base images
The choice of base image may vary depending on your selected approach—whether using a custom image or team customization. In either case, we recommend starting with a Dev Box-compatible base image that includes hibernation support to ensure optimal performance and compatibility.<br/>
To list available images in Dev Box, use the following command:

```shell
az devcenter admin image list --dev-center-name name --resource-group rgname --query "[].name"
```

The output should be something like the following:

```json
[
  "microsoftwindowsdesktop_windows-ent-cpc_win11-22h2-ent-cpc-os",
  "microsoftwindowsdesktop_windows-ent-cpc_win11-22h2-ent-cpc-m365",
  "microsoftwindowsdesktop_windows-ent-cpc_win10-22h2-ent-cpc-m365",
  "microsoftvisualstudio_visualstudio2019plustools_vs-2019-ent-general-win11-m365-gen2",
  "microsoftvisualstudio_visualstudio2019plustools_vs-2019-pro-general-win11-m365-gen2",
  "microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2",
  "microsoftvisualstudio_visualstudioplustools_vs-2022-pro-general-win11-m365-gen2",
  "microsoftvisualstudio_visualstudio2019plustools_vs-2019-ent-general-win10-m365-gen2",
  "microsoftvisualstudio_visualstudio2019plustools_vs-2019-pro-general-win10-m365-gen2",
  "microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win10-m365-gen2",
  "microsoftvisualstudio_visualstudioplustools_vs-2022-pro-general-win10-m365-gen2",
  "microsoftvisualstudio_windowsplustools_base-win11-gen2",
  "microsoftwindowsdesktop_windows-ent-cpc_win11-23h2-ent-cpc-m365",
  "microsoftwindowsdesktop_windows-ent-cpc_win11-23h2-ent-cpc",
  "microsoftwindowsdesktop_windows-ent-cpc_win11-22h2-ent-cpc",
  "microsoftwindowsdesktop_windows-ent-cpc_win10-22h2-ent-cpc",
  "microsoftwindowsdesktop_windows-ent-cpc_win11-24h2-ent-cpc-m365",
  "microsoftwindowsdesktop_windows-ent-cpc_win11-24h2-ent-cpc"
]
```

### Defining software and configuration requirements

To determine which software requires administrative privileges versus those that can be installed under a user's identity, it is essential to first compile a comprehensive list of all intended software installations. Additionally, categorizing software by user persona helps streamline configuration. If you identify common tools shared across multiple personas, consider adopting the **Baseline Image with Team Customizations** approach to enhance long-term maintainability and reduce duplication in your customization definition files.

### Managing image lifecycle and updates

To ensure Dev Box images remain secure, up to date, and aligned with organizational standards, it is the responsibility of the image owner to implement appropriate automation for image lifecycle management.

For **Full Custom Images** or **Baseline Images**, it is recommended to automate the image build process at regular intervals. This ensures that images include the latest Windows updates and software versions, enabling developers to provision Dev Boxes with a current and secure environment.

For those leveraging **Team Customizations** with the **pre-built image feature**, it is important to periodically rebuild the image to reflect any updates. As of this writing, automated scheduling and API-based triggers for image rebuilds are not yet available. Therefore, image rebuilds must be initiated manually through the Azure Portal. 

### Considerations

We strongly recommend to configure a [Dev Drive](https://learn.microsoft.com/en-us/windows/dev-drive/) for your Dev Boxes. Dev Drive is a new form of storage volume available to _improve performance for key developer workloads_.

If you are using Team Customizations (or user customizations), a dev-drive task is available [here](https://github.com/dstamand-msft/Devbox-Customizations/tree/main/Tasks/dev-drive) to be used in your configurations.

### References and additional resources
- [Microsoft Dev Box customizations
](https://learn.microsoft.com/en-us/azure/dev-box/concept-what-are-team-customizations?tabs=team-customizations)
- [Sample Team Customizations YAML](https://github.com/dstamand-msft/Devbox-Customizations/blob/main/teams-customizations.yaml)