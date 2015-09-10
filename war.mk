include ../../jarrules.mk

:ALL: cal008.war

JARTYPES=*.class|*.vxml|*.html|*.jsp|*.xsl|*.xml|*.gsl|*.dtd|*.xsd|*.js|*.fxml|*.cfg|*.std|*.params|*.wav|*.pdf|*.txt

cal008.war :JAR: . JARROOT=content 
