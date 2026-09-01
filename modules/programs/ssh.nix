# NOTDECL: Create ssh key using `ssh-keygen -i` and use `ssh-copy-id <server-name>` to copy public key to servers.
# NOTE: Replace manual key generation with `services.openssh.hostKeys` option.
{...}: {
  home = {
    file.".ssh/config".text = ''
    '';
  };
}
