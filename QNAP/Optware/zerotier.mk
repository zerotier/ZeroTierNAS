###########################################################
#
# zerotier
#
###########################################################
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
ZEROTIER_URL=https://github.com/zerotier/ZeroTierOne/archive/$(ZEROTIER_VERSION).tar.gz
ZEROTIER_VERSION=1.2.4
ZEROTIER_SOURCE=ZeroTierOne-$(ZEROTIER_VERSION).tar.gz
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
#ZEROTIER_CONFFILES=$(TARGET_PREFIX)/etc/zerotier.conf $(TARGET_PREFIX)/etc/init.d/SXXzerotier

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
# $(ZEROTIER_URL) holds the link to the source,
# which is saved to $(DL_DIR)/$(ZEROTIER_SOURCE).
# When adding new package, remember to place sha512sum of the source to
# scripts/checksums/$(ZEROTIER_SOURCE).sha512
#
$(DL_DIR)/$(ZEROTIER_SOURCE):
	$(WGET) -O $@ $(ZEROTIER_URL) || \
	$(WGET) -P $(@D) $(SOURCES_NLO_SITE)/$(@F)

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
# If the package uses  GNU libtool, you should invoke $(PATCH_LIBTOOL) as
# shown below to make various patches to it.
#
$(ZEROTIER_BUILD_DIR)/.configured: $(DL_DIR)/$(ZEROTIER_SOURCE) $(ZEROTIER_PATCHES) make/zerotier.mk
	#$(MAKE) <bar>-stage <baz>-stage
	rm -rf $(BUILD_DIR)/$(ZEROTIER_DIR) $(@D)
	$(ZEROTIER_UNZIP) $(DL_DIR)/$(ZEROTIER_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	if test -n "$(ZEROTIER_PATCHES)" ; \
		then cat $(ZEROTIER_PATCHES) | \
		$(PATCH) -d $(BUILD_DIR)/$(ZEROTIER_DIR) -p0 ; \
	fi
	if test "$(BUILD_DIR)/$(ZEROTIER_DIR)" != "$(@D)" ; \
		then mv $(BUILD_DIR)/$(ZEROTIER_DIR) $(@D) ; \
	fi
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(STAGING_CPPFLAGS) $(ZEROTIER_CPPFLAGS)" \
		LDFLAGS="$(STAGING_LDFLAGS) $(ZEROTIER_LDFLAGS)" \
		#./configure \
		#--build=$(GNU_HOST_NAME) \
		#--host=$(GNU_TARGET_NAME) \
		#--target=$(GNU_TARGET_NAME) \
		#--prefix=$(TARGET_PREFIX) \
		#--disable-nls \
		#--disable-static \
	)
	#$(PATCH_LIBTOOL) $(@D)/libtool
	touch $@

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
	@echo "Source: $(ZEROTIER_URL)" >>$@
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
	$(MAKE) -C $(ZEROTIER_BUILD_DIR) DESTDIR=$(ZEROTIER_IPK_DIR) install-strip
#	$(INSTALL) -d $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/etc/
#	$(INSTALL) -m 644 $(ZEROTIER_SOURCE_DIR)/zerotier.conf $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/etc/zerotier.conf
#	$(INSTALL) -d $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/etc/init.d
#	$(INSTALL) -m 755 $(ZEROTIER_SOURCE_DIR)/rc.zerotier $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/etc/init.d/SXXzerotier
#	sed -i -e '/^#!/aOPTWARE_TARGET=${OPTWARE_TARGET}' $(ZEROTIER_IPK_DIR)$(TARGET_PREFIX)/etc/init.d/SXXzerotier
	$(MAKE) $(ZEROTIER_IPK_DIR)/CONTROL/control
#	$(INSTALL) -m 755 $(ZEROTIER_SOURCE_DIR)/postinst $(ZEROTIER_IPK_DIR)/CONTROL/postinst
#	sed -i -e '/^#!/aOPTWARE_TARGET=${OPTWARE_TARGET}' $(ZEROTIER_IPK_DIR)/CONTROL/postinst
#	$(INSTALL) -m 755 $(ZEROTIER_SOURCE_DIR)/prerm $(ZEROTIER_IPK_DIR)/CONTROL/prerm
#	sed -i -e '/^#!/aOPTWARE_TARGET=${OPTWARE_TARGET}' $(ZEROTIER_IPK_DIR)/CONTROL/prerm
#	if test -n "$(UPD-ALT_PREFIX)"; then \
		sed -i -e '/^[ 	]*update-alternatives /s|update-alternatives|$(UPD-ALT_PREFIX)/bin/&|' \
			$(ZEROTIER_IPK_DIR)/CONTROL/postinst $(ZEROTIER_IPK_DIR)/CONTROL/prerm; \
	fi
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
	perl scripts/optware-check-package.pl --target=$(OPTWARE_TARGET) $^
