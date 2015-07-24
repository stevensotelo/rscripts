install.packages("RODBC")
library(RODBC)

channel <- odbcConnectAccess ("path_file")
my_Table <- sqlQuery( channel , paste ("select * from table_name"))
