if [ $EUID -ne 0 ]
        then
                echo "This program must run as root to function." 
                exit 1
fi

echo "This script will configure your grub config for virtualization."

GRUB=`cat /etc/default/grub | grep "GRUB_CMDLINE_LINUX_DEFAULT" | rev | cut -c 2- | rev`

grub_config="intel_iommu=on iommu=pt pcie_acs_override=downstream,multifunction nofb nomodeset video=vesafb:off,efifb:off"

# check if this string is present in the original string
if echo "$GRUB" | grep -q "$grub_config"; then
	echo "Your grub is already configured !"
else
	#adds amd_iommu=on and iommu=pt to the grub config
	#only intel_iommu=on iommu=pt are required, but the following are for the separation of iommu groups.
	GRUB+=" intel_iommu=on iommu=pt pcie_acs_override=downstream,multifunction nofb nomodeset video=vesafb:off,efifb:off\""
	sed -i -e "s|^GRUB_CMDLINE_LINUX_DEFAULT.*|${GRUB}|" /etc/default/grub

	grub-mkconfig -o /boot/grub/grub.cfg
	sleep 5s
	clear
	echo
	echo "Grub bootloader has been modified successfully, reboot time!"
	echo "press Y to reboot now and n to reboot later."
	read REBOOT

	if [ $REBOOT = "y" ]
		then                                                                                                                                                                                                                                  
		        reboot                                                                                                                                                                                                                       
	fi                                                                                                                                                                                                                                            
	exit
fi
