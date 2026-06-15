{
  writeShellScriptBin,
  qemu
}:
{
  kernel,
  initramfs,
  memory ? "1G",
}:
writeShellScriptBin "runvm" ''
  sudo ${qemu}/bin/qemu-system-x86_64 \
    -nic user,ipv6=off,model=rtl8139 \
    -enable-kvm \
    -m ${memory} \
    -kernel ${kernel}/bzImage \
    -initrd ${initramfs}/initrd.gz \
    -nographic -append "console=ttyS0" \
    -s
''

