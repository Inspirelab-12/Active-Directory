<# -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

There are 5 special roles for AD domain controllers called Flexible Single Master Operations (FSMO or Operations Master).

1. Schema Master
2. Domain Naming Master
3. PDC
4. RID Master
5. Infrastructure Master

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#>

# Transfer FSMO Roles Using PowerShell

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

Move-ADDirectoryServerOperationMasterRole -Identity "ADC1" PDCEmulator
Move-ADDirectoryServerOperationMasterRole -Identity "ADC1" RIDMaster
Move-ADDirectoryServerOperationMasterRole -Identity "ADC1" Infrastructuremaster
Move-ADDirectoryServerOperationMasterRole -Identity "ADC1" DomainNamingmaster
Move-ADDirectoryServerOperationMasterRole -Identity "ADC1" SchemaMaster

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

# Below Script can transfer several roles at once:

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

Move-ADDirectoryServerOperationMasterRole -Identity ADC1 –OperationMasterRole DomainNamingMaster,PDCEmulator,RIDMaster,SchemaMaster,InfrastructureMaster

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#