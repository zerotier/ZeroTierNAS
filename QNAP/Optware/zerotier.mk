###########################################################
#
# zerotier
#
###########################################################

# You must replace "zerotier" and "ZEROTIER" with the lower case name and
# upper case name of your new package.  Some places below will say
# "Do not change this" - that does not include this global change,
# which must always be done to ensure we have unique names.
#
# ZEROTIER_VERSION, ZEROTIER_SITE and ZEROTIER_SOURCE define
# the upstream location of the source code for the package.
# ZEROTIER_DIR is the directory which is created when the source
# archive is unpacked.
# ZEROTIER_UNZIP is the command used to unzip the source.
# It is usually "zcat" (for .gz) or "bzcat" (for .bz2)
#
# You should change all these variables to suit your package.
# Please make sure that you add a description, and that you
# list all your packages' dependencies, seperated by commas.
# 
# If you list yourself as MAINTAINER, please give a valid email
# address, and indicate your irc nick if it cannot be easily deduced
# from your name or email address.  If you leave MAINTAINER set to
# "NSLU2 Linux" other developers will feel free to edit.
#
ZEROTIER_SITE=https://github.com/zerotier/ZeroTierOne/archive/
ZEROTIER_VERSION=1.2.4
ZEROTIER_SOURCE=$(ZEROTIER_VERSION).tar.gz
ZEROTIER_DIR=ZeroTierOne-$(ZEROTIER_VERSION)
ZEROTIER_UNZIP=zcat
ZEROTIER_MAINTAINER=Joseph Henry <joseph.henry@zerotier.com>
ZEROTIER_DESCRIPTION=A Simple global P2P encrypted LAN for all of your devices.
ZEROTIER_SECTION=net
ZEROTIER_PRIORITY=optional
ZEROTIER_DEPENDS=
ZEROTIER_SUGGESTS=kernel-module-tun
ZEROTIER_CONFLICTS=

#
# ZEROTIER_IPK_VERSION should be incremented when the ipk changes.
#
ZEROTIER_IPK_VERSION=1

#
# ZEROTIER_CONFFILES should be a list of user-editable files
ZEROTIER_CONFFILES=
#$(TARGET_PREFIX)/etc/zerotier/zerotier.conf $(TARGET_PREFIX)/etc/zerotier/zerotier.up \
#$(TARGET_PREFIX)/etc/init.d/S20zerotier $(TARGET_PREFIX)/etc/xinetd.d/zerotier

#
# ZEROTIER_PATCHES should list any patches, in the the order in
# which they should be applied to the source code.
#
ZEROTIER_PATCHES=
#$(ZEROTIER_SOURCE_DIR)/configure.patch

#
# If the compilation of the package requires additional
# compilation or linking flags, then list them here.
#
ZEROTIER_CPPFLAGS=
#-fno-inline
ZEROTIER_LDFLAGS=

#
# ZEROTIER_BUILD_DIR is the directory in which the build is done.
# ZEROTIER_SOURCE_DIR is the directory which holds all the
# patches and ipkg control files.
# ZEROTIER_IPK_DIR is the directory in which the ipk is built.
# ZEROTIER_IPK is the name of the resulting ipk files.
#
# You should not change any of these variables.
#
ZEROTIER_BUILD_DIR=$(BUILD_DIR)/zerotier
ZEROTIER_SOURCE_DIR=$(SOURCE_DIR)/zerotier
ZEROTIER_IPK_DIR=$(BUILD_DIR)/zerotier-$(ZEROTIER_VERSION)-ipk
ZEROTIER_IPK=$(BUILD_DIR)/zerotier_$(ZEROTIER_VERSION)-$(ZEROTIER_IPK_VERSION)_$(TARGET_ARCH).ipk

.PHONY: zerotier-source zerotier-unpack zerotier zerotier-stage zerotier-ipk zerotier-clean zerotier-dirclean zerotier-check

#
# This is the dependency on the source code.  If the source is missing,
# then it will be fetched from the site using wget.
#
$(DL_DIR)/$(ZEROTIER_SOURCE):
	$(WGET) -P $(DL_DIR) $(ZEROTIER_SITE)/$(ZEROTIER_SOURCE) || \
	$(WGET) -P $(DL_DIR) $(SOURCES_NLO_SITE)/$(ZEROTIER_SOURCE)

#
# The source code depends on it existing within the download directory.
# This target will be called by the top level Makefile to download the
# source code's archive (.tar.gz, .bz2, etc.)
#
zerotier-source: $(DL_DIR)/$(ZEROTIER_SOURCE) $(ZEROTIER_PATCHES)

#
# This target unpacks the source code in the build directory.
# If the source archive is not .tar.gz or .tar.bz2, then you will need
# to change the commands here.  Patches to the source code are also
# applied in this target as required.
#
# This target also configures the build within the build directory.
# Flags such as LDFLAGS and CPPFLAGS should be passed into configure
# and NOT $(MAKE) below.  Passing it to configure causes configure to
# correctly BUILD the Makefile with the right paths, where passing it
# to Make causes it to override the default search paths of the compiler.
#
# If the compilation of the package requires other packages to be staged
# first, then do that first (e.g. "$(MAKE) <bar>-stage <baz>-stage").
#
$(ZEROTIER_BUILD_DIR)/.configured: $(DL_DIR)/$(ZEROTIER_SOURCE) $(ZEROTIER_PATCHES) make/zerotier.mk
#	$(MAKE) lzo-stage
#ifneq ($(HOST_MACHINE),armv5b)
#	$(MAKE) openssl-stage
#endif
#	rm -rf $(BUILD_DIR)/$(ZEROTIER_DIR) $(@D)
#	$(ZEROTIER_UNZIP) $(DL_DIR)/$(ZEROTIER_SOURCE) | tar -C $(BUILD_DIR) -xvf -
#	if test -n "$(ZEROTIER_PATCHES)" ; \
#		then cat $(ZEROTIER_PATCHES) | \
#		$(PATCH) -d $(BUILD_DIR)/$(ZEROTIER_DIR) -p0 ; \
#	fi
#	if test "$(BUILD_DIR)/$(ZEROTIER_DIR)" != "$(@D)" ; \
#		then mv $(BUILD_DIR)/$(ZEROTIER_DIR) $(@D) ; \
#	fi
#	(cd $(@D); \
#		$(TARGET_CONFIGURE_OPTS) \
#		CPPFLAGS="$(STAGING_CPPFLAGS) $(ZEROTIER_CPPFLAGS)" \
#		LDFLAGS="$(STAGING_LDFLAGS) $(ZEROTIER_LDFLAGS)" \
#		./configure \
#		--build=$(GNU_HOST_NAME) \
#		--host=$(GNU_TARGET_NAME) \
#		--target=$(GNU_TARGET_NAME) \
#		--prefix=$(TARGET_PREFIX) \
#		--disable-nls \
#		--enable-password-save \
#	)
#	touch $@

zerotier-unpack: $(ZEROTIER_BUILD_DIR)/.configured

#
# This builds the actual binary.
#
$(ZEROTIER_BUILD_DIR)/.built: $(ZEROTIER_BUILD_DIR)/.configured
	rm -f $@
	$(MAKE) -C $(@D)
	touch $@

#
# This is the build convenience target.
#
zerotier: $(ZEROTIER_BUILD_DIR)/.built

#
# If you are building a library, then you need to stage it too.
#
$(ZEROTIER_BUILD_DIR)/.staged: $(ZEROTIER_BUILD_DIR)/.built
	rm -f $@
	$(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
	touch $@

zerotier-stage: $(ZEROTIER_BUILD_DIR)/.staged

#
# This rule creates a control file for ipkg.  It is no longer
# necessary to create a seperate control file under sources/zerotier
#
$(ZEROTIER_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: zerotier" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(ZEROTIER_PRIORITY)" >>$@
	@echo "Section: $(ZEROTIER_SECTION)" >>$@
	@echo "Version: $(ZEROTIER_VERSION)-$(ZEROTIER_IPK_VERSION)" >>$@
	@echo "Maintainer: $(ZEROTIER_MAINTAINER)" >>$@
	@echo "Source: $(ZEROTIER_SITE)/$(ZEROTIER_SOURCE)" >>$@
	@echo "Description: $(ZEROTIER_DESCRIPTION)" >>$@
	@echo "Depends: $(ZEROTIER_DEPENDS)" >>$@
	@echo "Suggests: $(ZEROTIER_SUGGESTS)" >>$@
	@echo "Conflicts: $(ZEROTIER_CONFLICTS)" >>$@

#
# This builds the IPK file.
#
# Binaries should be installed into $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/sbin or $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/bin
# (use the location in a well-known Linux distro as a guide for choosing sbin or bin).
# Libraries and include files should be installed into $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/{lib,include}
# Configuration files should be installed in $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/etc/zerotier/...
# Documentation files should be installed in $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/doc/zerotier/...
# Daemon startup scripts should be installed in $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/etc/init.d/S??zerotier
#
# You may need to patch your application to make it use these locations.
#
$(ZEROTIER_IPK): $(ZEROTIER_BUILD_DIR)/.built
	rm -rf $(ZEROTIER_IPK_DIR) $(BUILD_DIR)/zerotier_*_$(TARGET_ARCH).ipk
	# Install server to $(TARGET_PREFIX)/sbin
	$(INSTALL) -d $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/sbin
	$(STRIP_COMMAND) $(ZEROTIER_BUILD_DIR)/zerotier -o $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/sbin/zerotier

	# xinetd startup file
	$(INSTALL) -d $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/etc/xinetd.d
	$(INSTALL) -m 755 $(ZEROTIER_SOURCE_DIR)/zerotier.xinetd $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/etc/xinetd.d/zerotier

	# init.d startup file
	$(INSTALL) -d $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/etc/init.d
	$(INSTALL) -m 755 $(ZEROTIER_SOURCE_DIR)/S20zerotier $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/etc/init.d

	# zerotier config files
	$(INSTALL) -d $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/etc/zerotier
	$(INSTALL) -m 644 $(ZEROTIER_SOURCE_DIR)/zerotier.conf $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/etc/zerotier
	$(INSTALL) -m 755 $(ZEROTIER_SOURCE_DIR)/zerotier.up $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/etc/zerotier

	# zerotier loopback test 
	$(INSTALL) -d $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/etc/zerotier/sample-config-files
	$(INSTALL) -m 644 $(ZEROTIER_BUILD_DIR)/sample-config-files/* $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/etc/zerotier/sample-config-files

	# zerotier sample keys
	$(INSTALL) -d $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/etc/zerotier/sample-keys
	$(INSTALL) -m 644 $(ZEROTIER_BUILD_DIR)/sample-keys/* $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/etc/zerotier/sample-keys

	# zerotier sample scripts
	$(INSTALL) -d $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/etc/zerotier/sample-scripts
	$(INSTALL) -m 644 $(ZEROTIER_BUILD_DIR)/sample-scripts/* $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/etc/zerotier/sample-scripts

	# Install man pages
	$(INSTALL) -d $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/man/man8
	$(INSTALL) -m 644 $(ZEROTIER_BUILD_DIR)/zerotier.8 $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/man/man8

	# Create log directory
	$(INSTALL) -d $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/var/log/zerotier

	# Install control files
	make  $(ZEROTIER_IPK_DIR)/CONTROL/control
#	$(INSTALL) -m 644 $(ZEROTIER_SOURCE_DIR)/postinst $(ZEROTIER_IPK_DIR)/CONTROL
#	$(INSTALL) -m 644 $(ZEROTIER_SOURCE_DIR)/prerm $(ZEROTIER_IPK_DIR)/CONTROL
	echo $(ZEROTIER_CONFFILES) | sed -e 's/ /\n/g' > $(ZEROTIER_IPK_DIR)/CONTROL/conffiles
	cd $(BUILD_DIR); $(IPKG_BUILD) $(ZEROTIER_IPK_DIR)
	$(WHAT_TO_DO_WITH_IPK_DIR) $(ZEROTIER_IPK_DIR)


#
# This is called from the top level makefile to create the IPK file.
#
zerotier-ipk: $(ZEROTIER_IPK)

#
# This is called from the top level makefile to clean all of the built files.
#
zerotier-clean:
	rm -f $(ZEROTIER_BUILD_DIR)/.built
	-$(MAKE) -C $(ZEROTIER_BUILD_DIR) clean

#
# This is called from the top level makefile to clean all dynamically created
# directories.
#
zerotier-dirclean:
	rm -rf $(BUILD_DIR)/$(ZEROTIER_DIR) $(ZEROTIER_BUILD_DIR) $(ZEROTIER_IPK_DIR) $(ZEROTIER_IPK)
#
#
# Some sanity check for the package.
#
zerotier-check: $(ZEROTIER_IPK)
	perl scripts/optware-check-package.pl --target=$(OPTWARE_TARGET) $(ZEROTIER_IPK)
