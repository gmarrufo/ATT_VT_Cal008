#ident  "@(#)cal008.spec	559.1.1.1 app001.spec delta: 08/27/10 16:29:00 get: 11/10/10 12:20:17"
# *********************************
#This section and the %description section  are the equivalent of the pkginfo file in the solaris package 
#**********************************    
Summary: cal008 
Name: cal008
Version: 1.0.0
Release: cs
Copyright: AT&T
Group: Applications/Vtone/apps
Source: file://cal008CS.tar
# MUST set Buildroot to builddir - do not change!
BuildRoot: %{_builddir}

%description
WEVS application - cal008 app.

%prep
# Avoid the standard %setup macro
# 	this macro will not untar files in the required directories for vtone

# ****************************
# This section unpacks the tar file created in the first target of rpm.mk
# It also 
# 1.  Creates all the directories that need to be installed on the target server# for inclusion into the rpm
# 2. Organizes the directories and files as they need to be installed
# As you can see this is accomplished by means of linux commands such as mkdir, # cp etc
#*****************************
rm -rf %{_builddir}/usr/local/vtone/apps
mkdir -p %{_builddir}/usr/local/vtone/apps/%{name}
mkdir -p %{_builddir}/usr/local/vtone/apps/%{name}/conf
mkdir -p %{_builddir}/usr/local/vtone/apps/%{name}/logs
mkdir -p %{_builddir}/usr/local/vtone/apps/web-apps
###
### making audio dirs for FSU
###
mkdir -p %{_builddir}/var/spool/audio
mkdir -p %{_builddir}/var/spool/audio/%{name}
mkdir -p %{_builddir}/var/spool/audio/%{name}/english
mkdir -p %{_builddir}/var/spool/audio/%{name}/spanish
mkdir -p %{_builddir}/var/spool/audio/%{name}/vietnamese
mkdir -p %{_builddir}/var/spool/audio/%{name}/cantonese
mkdir -p %{_builddir}/var/spool/audio/%{name}/hmong

# UNTAR THE PASSED TAR FILE (Source0) under /usr/local/vtone/%{name}
cd %{_builddir}/usr/local/vtone/apps/%{name}
tar -xvf %{SOURCE0}
# copy xml , sh cfg files into conf directory
cp cal008.war %{_builddir}/usr/local/vtone/apps/web-apps/cal008.war
# cp content/*.xml %{_builddir}/usr/local/vtone/apps/%{name}/conf
# cp content/*.cfg %{_builddir}/usr/local/vtone/apps/%{name}/conf

#******************************
# Incorporate any cron entries that need to be part of your rpm instllation. 
# Please note that it is necessary to create an <appid>.cron file 
#******************************
# Move any Cron files to /etc/cron.d
#rm -rf %{_builddir}/etc/cron.d/*
#mkdir -p %{_builddir}/etc/cron.d
#croncnt=`ls %{_builddir}/usr/local/vtone/apps/%{name}/rpm/%{release}/*.cron 2>/dev/null |wc -l`
#if [ "$croncnt" -gt 0 ]
#then
	#cd %{_builddir}/usr/local/vtone/apps/%{name}/rpm/%{release}
	#for cronfile in *.cron
	#do
		#cp $cronfile %{_builddir}/etc/cron.d/.
	#done
#fi

%build
# Normally don't need to do anything here for voicetone 

%install
# Normally don't need to do anything here for voicetone 

%files
# MUST name any directories (under /usr/local/vtone/plat) that your rpm will install. 
# %defattr(755,wevs,wevs)

# list directories
%dir %attr(755,wevs,wevs) /usr/local/vtone/apps/%{name}
%dir %attr(755,wevs,wevs) /usr/local/vtone/apps/%{name}/conf
%dir %attr(755,wevs,wevs) /usr/local/vtone/apps/%{name}/logs
%dir %attr(755,wevs,wevs) /usr/local/vtone/apps/%{name}/rpm/%{release}
%dir %attr(755,wevs,wevs) /usr/local/vtone/apps/web-apps

# audio dirs for FSU
%dir %attr(755,wevs,wevs) /var/spool/audio
%dir %attr(755,wevs,wevs) /var/spool/audio/%{name}
%dir %attr(755,wevs,wevs) /var/spool/audio/%{name}/english
%dir %attr(755,wevs,wevs) /var/spool/audio/%{name}/spanish
%dir %attr(755,wevs,wevs) /var/spool/audio/%{name}/vietnamese
%dir %attr(755,wevs,wevs) /var/spool/audio/%{name}/cantonese
%dir %attr(755,wevs,wevs) /var/spool/audio/%{name}/hmong

# List the files
%attr(644,wevs,wevs) /usr/local/vtone/apps/web-apps/cal008.war

# config file - list if you have them over here
#%attr(644,wevs,wevs) /usr/local/vtone/apps/%{name}/conf/*.xml
#%attr(644,wevs,wevs) /usr/local/vtone/apps/%{name}/conf/*.cfg
#%attr(755,wevs,wevs) /usr/local/vtone/apps/%{name}/conf/*.sh

# postinstall and preremove files
%attr(755,wevs,wevs) /usr/local/vtone/apps/%{name}/rpm/%{release}/postinstall

# This line works for identifying cron files - only uncomment below line if you have cron file
#%attr(644, root, root) /etc/cron.d/*

# Now start listing all the files your rpm will install
#%defattr(755, wevs,wevs)

%clean
# This section should be standard for all rpms.
#  NOTE: But if you add any additional directories or files - you should clean
#        them up by adding rm statements here!
#        BUT - please contact zorro admin to inspect your clean section. It
#              is possible for you to delete files/directories you did not 
#              intend to if you are not careful.
echo " In clean - RPM_BUILD ROOT = $RPM_BUILD_ROOT"
rm -rf %{_builddir}/usr
rm -rf %{_builddir}/etc

%pre
# DEVELOPER MUST ADD ANY PRE INSTALLATION INSTRUCTIONS HERE
#echo Running preinstall script!

%post
# DEVELOPER can simply place postinstall under rpm/<release> directory in 
# the tar file named as Source, and these lines will execute that script after
# the rpm is installed.
#echo Run any postinstall scripts found in the tar file!
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

#echo Run any pre unistall scripts found in the tar file!
if [ -s /usr/local/vtone/apps/%{name}/rpm/%{release}/preremove ]
then
	sh /usr/local/vtone/apps/%{name}/rpm/%{release}/preremove
fi

%postun
# DEVELOPER MUST ADD ANY POST REMOVE INSTRUCTIONS HERE
echo Undeploying cal008 from WebLogic
wlsdeployer remove -a cal008


%changelog
*  Mon Apr 4 2011  Louis Brown
- Initial rpm for cal008 - content server package
