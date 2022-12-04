#connects to azureAD
connect-azaccount

#lists all VMs in sub so user can ensure name is accurately typed.
Echo "Virtual Machine Names"
Echo (Get-azvm).name
$VM= Read-host "Please Enter VM Name. Please type complete VM name accurately."

#sets variables
$vm= Get-azvm -name $VM
$vmname=$vm.name

#removesVM
remove-azvm -name $vmname -resourcegroup $vm.resourcegroupname -force

#removesnetworkinterface
$networkinterface = get-aznetworkinterface | where {$_.name -like [string]"*$vmname*"}
if ($networkinterface -ne $null)
{
    remove-aznetworkinterface -name $networkinterface.name -resourcegroup $networkinterface.resourcegroupname -force
}

#removes network security groups
$networksecuritygroup = (get-aznetworksecuritygroup | where {$_.name -like [string]"*$vmname*"})
if ($networksecuritygroup -ne $null)
{
    remove-aznetworksecuritygroup -name $networksecuritygroup.name -resourcegroup $networksecuritygroup.resourcegroupname -force
}

#removes public IP Address
$publicip = get-azpublicipaddress | where {$_.name -like [string]"*$vmname*"}
if ($publicip -ne $null)
{
    remove-azpublicipaddress -name $publicip.name -resourcegroup $publicip.resourcegroupname -force
}

#Places all datadisks into a variable, then deletes them. 
$datadisks = $vm.storageprofile.datadisks.name
if ($datadisks -ne $null)
{
    Foreach ($datadisk in $datadisks)
    {
        remove-azdisk -name $datadisk -resourcegroup $vm.resourcegroupname -force
    }
}
