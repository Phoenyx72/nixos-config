function update
    echo "Updating NixOS..."
    if sudo nixos-rebuild switch --upgrade
        echo "Cleaning up..."
		sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old
        sudo nix-collect-garbage -d > /dev/null 2>&1
        echo "Optimizing store..."
        sudo nix-store --optimise > /dev/null 2>&1
        echo "Done."
	# sudo tee -a /boot/EFI/refind/refind.conf < /etc/nixos/refind/refind.conf
	# sudo cp -r /etc/nixos/refind/themes /boot/efi/refind/
	else
        echo "Update failed. Skipping garbage collection."
    end
end
