obj-m += helloworld.o
#$KERNEL here is the computed store path of the derivation kernel.dev which was defined in flake.nix and exported as an Enviroment variable.
KDIR := $(KERNEL)/lib/modules/$(KERNEL_VERSION)/build

all:
	make -C $(KDIR) M=$(PWD) modules

clean:
	make -C $(KDIR) M=$(PWD) clean

