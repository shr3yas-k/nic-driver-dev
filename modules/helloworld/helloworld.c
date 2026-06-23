#define pr_fmt(fmt) "%s:%s(): " fmt, KBUILD_MODNAME, __func__

#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/pci.h>

MODULE_AUTHOR("Shreyas Kamalapuram");
MODULE_DESCRIPTION("Hello world module");
MODULE_LICENSE("Dual MIT/GPL");
MODULE_VERSION("0.1");

//borrowed from linux/drivers/net/ethernet/realtek/8139too.c
static const struct pci_device_id rtl8139_pci_tbl[] = {
	{ PCI_DEVICE(0x10ec, 0x8139),},
	{ PCI_DEVICE(0x10ec, 0x8138),},
	{ PCI_DEVICE(0x1113, 0x1211),},
	{ PCI_DEVICE(0x1500, 0x1360),},
	{ PCI_DEVICE(0x4033, 0x1360),},
	{ PCI_DEVICE(0x1186, 0x1300),},
	{ PCI_DEVICE(0x1186, 0x1340),},
	{ PCI_DEVICE(0x13d1, 0xab06),},
	{ PCI_DEVICE(0x1259, 0xa117),},
	{ PCI_DEVICE(0x1259, 0xa11e),},
	{ PCI_DEVICE(0x14ea, 0xab06),},
	{ PCI_DEVICE(0x14ea, 0xab07),},
	{ PCI_DEVICE(0x11db, 0x1234),},
	{ PCI_DEVICE(0x1432, 0x9130),},
	{ PCI_DEVICE(0x02ac, 0x1012),},
	{ PCI_DEVICE(0x018a, 0x0106),},
	{ PCI_DEVICE(0x126c, 0x1211),},
	{ PCI_DEVICE(0x1743, 0x8139),},
	{ PCI_DEVICE(0x021b, 0x8139),},
	{ PCI_DEVICE(0x16ec, 0xab06),},
  { }
};

MODULE_DEVICE_TABLE (pci, rtl8139_pci_tbl);

static void remove(struct pci_dev *dev){};	

static int probe(struct pci_dev *dev, const struct pci_device_id *id){
  return 0;
};

static struct pci_driver pci_driver = {
  .name = "pci_skel",
  .id_table = rtl8139_pci_tbl,
  .probe = probe,
  .remove = remove,
};

static int __init hello_init(void)
{
	pr_info("Hello, world\n");

	return 0; 
}

static void __exit hello_exit(void)
{
	pr_info("Goodbye, world\n");
}

module_init(hello_init);
module_exit(hello_exit);
