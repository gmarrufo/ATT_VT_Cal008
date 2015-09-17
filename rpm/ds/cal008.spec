Summary: WEVS: Platform feature 
Name: cal008
Version: 1.0.0
Release: ds
Copyright: AT&T
Group: Applications/Vtone/apps
Source: file://cal008DB.tar
# MUST set Buildroot to builddir - do not change!
BuildRoot: %{_builddir}

%description
cal008 - Database script to create tables for cal008 application.

%prep
# Avoid the standard %setup macro
# 	this macro will not untar files in the required directories for vtone

# The following will unpack your tar file. And if you have any .cron files
# under an rpm/<release> directory - these are prepared for installation
# as well.
# NOTE: You still need to add your cron files to the %files section of the
#       spec file.

# UNTAR THE PASSED TAR FILE (Source0) under /usr/local/vtone/%{name}
rm -rf %{_builddir}/usr/local/vtone/apps/%{name}
mkdir -p %{_builddir}/usr/local/vtone/apps/%{name}
cd %{_builddir}/usr/local/vtone/apps/%{name}
tar -xvf %{SOURCE0}

# Change target directory
mkdir %{_builddir}/usr/local/vtone/apps/%{name}/sql
cd %{_builddir}/usr/local/vtone/apps/%{name}/sql
cp %{_builddir}/usr/local/vtone/apps/%{name}/database/* .

# Move any Cron files to /etc/cron.d
#rm -rf %{_builddir}/etc/cron.d/*
#mkdir -p %{_builddir}/etc/cron.d
#croncnt=`ls %{_builddir}/usr/local/vtone/apps/%{name}/rpm/%{release}/*.cron 2>/dev/null |wc -l`
#if [ "$croncnt" -gt 0 ]
#then
#	cd %{_builddir}/usr/local/vtone/apps/%{name}/rpm/%{release}
#	for cronfile in *.cron
#	do
#		cp $cronfile %{_builddir}/etc/cron.d/.
#	done
#fi

%build
# Normally don't need to do anything here for voicetone 

%install
# Normally don't need to do anything here for voicetone 

%files
# MUST name any directories (under /usr/local/vtone/apps) that your rpm will
# install. 
%defattr(755,wevs,wevs)
# top feature directory
%dir /usr/local/vtone/apps/%{name}
# directories to support postinstall preremove
%dir /usr/local/vtone/apps/%{name}/rpm
%dir /usr/local/vtone/apps/%{name}/rpm/%{release}
# Application specific directories
%dir /usr/local/vtone/apps/%{name}/sql

# Then you MUST name any and all files (under /usr/local/vtone/apps) that your
# rpm will install. This includes any cron files and postinstall or preremove
# scripts.

# postinstall and preremove files
%attr(755, root, root) /usr/local/vtone/apps/%{name}/rpm/%{release}/postinstall
#%attr(755, root, root) /usr/local/vtone/apps/%{name}/rpm/%{release}/preremove

# This line works for identifying cron files
#%attr(644, root, root) /etc/cron.d/*

# Now start listing all the files your rpm will install
%defattr(755, wevs,wevs)

#### App, Rpt, Host related files ####
/usr/local/vtone/apps/%{name}/sql/*.dat
/usr/local/vtone/apps/%{name}/sql/*.ctl
/usr/local/vtone/apps/%{name}/sql/*.sh
/usr/local/vtone/apps/%{name}/sql/*.sql
#/usr/local/vtone/apps/%{name}/sql/*.xml
#/usr/local/vtone/apps/%{name}/sql/*.xsl

%clean
# This section should be standard for all rpms.
#  NOTE: But if you add any additional directories or files - you should clean
#        them up by adding rm statements here!
#        BUT - please contact zorro admin to inspect your clean section. It
#              is possible for you to delete files/directories you did not 
#              intend to if you are not careful.
echo " In clean - RPM_BUILD ROOT = $RPM_BUILD_ROOT"
rm -rf %{_builddir}/usr/local/vtone/apps/%{name}
#rm -rf %{_builddir}/etc/cron.d/*

%pre
# DEVELOPER MUST ADD ANY PRE INSTALLATION INSTRUCTIONS HERE
echo Running preinstall script!

%post
# DEVELOPER can simply place postinstall under rpm/<release> directory in 
# the tar file named as Source, and these lines will execute that script after
# the rpm is installed.
echo Run any postinstall scripts found in the tar file!
if [ -s /usr/local/vtone/apps/%{name}/rpm/%{release}/postinstall ]
then
	sh /usr/local/vtone/apps/%{name}/rpm/%{release}/postinstall
fi

%preun
# DEVELOPER can simply place preremove under rpm/<release> directory in 
# the tar file named as Source, and these lines will execute that script before
# the rpm is uninstalled.
echo The number of packages installed is $1
if [ $1 != 0 ]
then
	echo Another version of this rpm is installed - do not run preremove script.
	exit 0
fi
echo Run any pre unistall scripts found in the tar file!
if [ -s /usr/local/vtone/apps/%{name}/rpm/%{release}/preremove ]
then
	sh /usr/local/vtone/apps/%{name}/rpm/%{release}/preremove
fi

%postun
# DEVELOPER MUST ADD ANY POST REMOVE INSTRUCTIONS HERE
echo Running any post uninstall scripts!

# Initial rpm for cal008 - database package

