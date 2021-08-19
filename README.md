# NinjaRMM - A [PowerShell](https://microsoft.com/powershell) module for [NinjaRMM](https://ninjarmm.com/) software

[![Azure DevOps Pipeline Status](https://img.shields.io/azure-devops/tests/MSPsUK/NinjaRMM/4?style=for-the-badge)](https://dev.azure.com/MSPsUK/NinjaRMM/_build?definitionId=1)
[![Azure DevOps Code Coverage](https://img.shields.io/azure-devops/coverage/MSPsUK/NinjaRMM/4?style=for-the-badge)](https://dev.azure.com/MSPsUK/NinjaRMM/_build?definitionId=1)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/NinjaRMM?style=for-the-badge)](https://www.powershellgallery.com/packages/NinjaRMM/)
[![License](https://img.shields.io/github/license/homotechsual/NinjaRMMstyle=for-the-badge)](https://ninjarmmapi.mit-license.org/)
[![GitHub Sponsors](https://img.shields.io/github/sponsors/homotechsual?style=for-the-badge)](https://github.com/sponsors/homotechsual/)
[![Stable Release](https://img.shields.io/powershellgallery/v/NinjaRMM?label=Stable+Release&style=for-the-badge)](https://www.powershellgallery.com/packages/NinjaRMM/)
[![Preview Release](https://img.shields.io/powershellgallery/v/NinjaRMM?label=Preview+Release&include_prereleases&style=for-the-badge)](https://www.powershellgallery.com/packages/NinjaRMM/)

## Who am I?

I am Mikey O'Toole ([@homotechsual](https://github.com/homotechsual)) the founder and director for a UK-based managed IT services provider with a passion for automation and good quality MSP software tools.

## What is this?

This is the code for a [PowerShell](https://microsoft.com/powershell) module for the [Ninja RMM](https://ninjarmm.com/) platform.

The module is written for [PowerShell 7](https://docs.microsoft.com/en-us/powershell/scripting/whats-new/what-s-new-in-powershell-71?view=powershell-7.1). **It is not compatible with Windows PowerShell 5.1 and never will be.**. This module is licensed under the [MIT](https://ninjarmmapi.mit-license.org/) license.

## What does it do?

NinjaRMM provides a PowerShell wrapper around the Halo API, tested extensively against HaloPSA instances only (please test against HaloISM or HaloServiceDesk instances and let us know how it works). The module can retrieve and send information to the Halo API.

## Installing

This module is published to the PowerShell Gallery and can be installed from within PowerShell with `Install-Module`

```PowerShell
Install-Module NinjaRMM -AllowPrerelease
```

## Getting Started

The first and probably most important requirement for this module is getting it connected to NinjaRMM instance.

### Creating an API application in NinjaRMM

1. In your NinjaRMM tenant head to **Configuration** > **Integrations** > **API**.

1. Click on **Client App IDs**  
All going well you should be at `configuration/integrations/api/client`.

1. Click on **Add** to add a new API application.

1. Set the **Application Platform** to *Web (PHP, Java, .Net Core, etc.)*

1. Enter the **Name**.  
For example *NinjaRMM API PS Module*.

1. In the **Redirect URIs** box enter *`http://localhost:9090`*
You can use any port number here just make sure you remember it and adjust the `Connect-NinjaRMM` command below appropriately.

1. Set the **Scopes** appropriately. If you want to be able to do anything using the API select all three scopes. Otherwise select them as appropriate for your needs:

    * Monitoring -  *This provides access to most of the `Get-*` commands.*
    * Management - *This provides access to most of the management functionality like agent installer generation.*
    * Control - *This provides access to control settings and make changes to the configuration of you Ninja tenant.*

1. Set the **Allowed Grant Types** to *Authorization Code* and *Refresh Token*.
Authorization code is used for the initial login, the refresh token is used to maintain access on subsequent logins.

1. Click on **Save** and **Complete the MFA challenge**.

1. Store the **Client Secret** securely and close the small popup window.

1. Click on **Close** and on the **Client App IDs** screen copy the **Client ID** for your application. Store this with your **Client Secret**.

### Connecting the PowerShell module to the API (first time / authorisation code flow)

1. Install the NinjaRMM PowerShell module on PowerShell 7.0 or above.  

    ```PowerShell
    Install-Module NinjaRMM -AllowPrerelease
    ```

1. Make sure you have all the information you need to connect:

    * Your NinjaRMM instance this could be:
        * **EU** `https://eu.ninjarmm.com`
        * **OC** `https://oc.ninjarmm.com`
        * **US** `https://app.ninjarmm.com`
    * Your client ID and client secret.
    * The port you chose for your redirect URI.

1. Connect to the NinjaRMM API with `Connect-NinjaRMM`  

    ```PowerShell
    # Splat the parameters - easier to read!
    $ConnectionParameters = @{
        Instance = 'eu'
        ClientID = 'ABCDEfGH-IjKLmnopqrstUV1w23x45yz'
        ClientSecret = 'abc123abc123def456def456ghi789ghi789lmn012lmn012'
        Port = 9090
        UseWebAuth = $True
        ShowTokens = $True
    }

    Connect-NinjaRMM @ConnectionParameters
    ```

    * Let's disect those last two parameters:
        * `UseWebAuth` tells the module that we need to login to NinjaRMM to get an authorisation code. This uses a local `.NET` Kestrel based webserver that listens on the port you pass and handles the reponse that Ninja sends to `http://localhost:9090` - the Redirect URI we configured earlier.
        * `ShowTokens` tells the module that you want to see the generated refresh token - so that when you next authenticate you can use that refresh token instead of logging in again and generating a new set of tokens.

    ```PowerShell
    # Pass the parameters individually - more familiar!
    Connect-NinjaRMM -Instance 'eu' -ClientID 'ABCDEfGH-IjKLmnopqrstUV1w23x45yz' -ClientSecret 'abc123abc123def456def456ghi789ghi789lmn012lmn012' -Port 9090 -UseWebAuth -ShowTokens
    ```

### Connecting the PowerShell module to the API (subsequent times / refresh token flow)

1. Connect to the NinjaRMM API with `Connect-NinjaRMM`  

    ```PowerShell
    # Splat the parameters - easier to read!
    $ReconnectionParameters = @{
        Instance = 'eu'
        ClientID = 'ABCDEfGH-IjKLmnopqrstUV1w23x45yz'
        ClientSecret = 'abc123abc123def456def456ghi789ghi789lmn012lmn012'
        RefreshToken = 'abc123abc123defABCDEfGH-IjKLmnopqrstUV1w-23x45yz456def456ghi789ghi7-89lmn012lmn012'
        UseTokenAuth = $True
    }

    Connect-NinjaRMM @ReconnectionParameters
    ```

    * Let's disect those last two parameters:
        * `RefreshToken` this is the token we get from the initial *authorisation code flow* login.
        * `UseTokenAuth` tells the module that we have a refresh token so we want to bypass the authorisation code steps and just exchange it inside the module for an access token the module can use to authenticate to NinjaRMM.

    ```PowerShell
    # Pass the parameters individually - more familiar!
    Connect-NinjaRMM -Instance 'eu' -ClientID 'ABCDEfGH-IjKLmnopqrstUV1w23x45yz' -ClientSecret 'abc123abc123def456def456ghi789ghi789lmn012lmn012' -RefreshToken 'abc123abc123defABCDEfGH-IjKLmnopqrstUV1w-23x45yz456def456ghi789ghi7-89lmn012lmn012' -UseTokenAuth
    ```
