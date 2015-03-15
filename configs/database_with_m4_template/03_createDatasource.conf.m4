include(config.m4)dnl

/subsystem=datasources/data-source=bookingDatasource:add( 	\
	jndi-name="java:/datasources/bookingDatasource", 		\
	connection-url="jdbc:h2:mem:test;DB_CLOSE_DELAY=-1", 	\
	driver-name=h2, user-name=CONF_DB_USER, password=CONF_DB_PASSWORD)

/subsystem=datasources/data-source=bookingDatasource:enable
