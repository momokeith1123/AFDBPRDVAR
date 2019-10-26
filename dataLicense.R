library("RODBC")
ch <- odbcConnect("V56_R", uid = "v56report", pwd = "v56report")
# sqlTables(ch, tableType = "TABLE")
# sqlTables(ch, schema = "some pattern")
# sqlTables(ch, tableName = "some pattern")

dmcust <- sqlQuery(ch,"select * from V56.dmcustomer where audit_current ='Y'")
