set hive.support.concurrency=true;
set hive.txn.manager=org.apache.hadoop.hive.ql.lockmgr.DbTxnManager;
set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;
set hive.enforce.bucketing=true;

dfs ${system:test.dfs.mkdir} ${system:test.tmp.dir}/update_orig_table;
dfs -copyFromLocal ../../data/files/alltypesorc ${system:test.tmp.dir}/update_orig_table/00000_0; 

create table acid_uot(
    ctinyint TINYINT,
    csmallint SMALLINT,
    cint INT,
    cbigint BIGINT,
    cfloat FLOAT,
    cdouble DOUBLE,
    cstring1 STRING,
    cstring2 STRING,
    ctimestamp1 TIMESTAMP,
    ctimestamp2 TIMESTAMP,
    cboolean1 BOOLEAN,
    cboolean2 BOOLEAN) clustered by (cint) into 1 buckets stored as orc location '${system:test.tmp.dir}/update_orig_table';

update acid_uot set cstring1 = 'fred' where cint < -1070551679;

select * from acid_uot where cstring1 = 'fred';

dfs -rmr ${system:test.tmp.dir}/update_orig_table;
