# This SQL script works against a database with results from the Stacks pipeline (aligns short sequence reads,
# in this case RAD-seq data, into ”stacks”/loci and calls SNPs in this loci). I used this to get information
# on the total read depth of each such locus, and read depth of each individual sample (there were 56 trout
# individuals sequenced) at each locus.


# Extract read depth information from table matches to new table, index new table for speed
create table zz401_Depth_master (select catalog_id, sample_id, depth from matches);
alter table zz401_Depth_master add index catalog_id_index (catalog_id asc);
alter table zz401_Depth_master add index sample_id_index (sample_id asc);
alter table zz401_Depth_master add index depth_index (depth asc);

# Sum total read depth per locus in new table
create table zz402_Depth_per_locus (select catalog_id, sum(depth) as depth from zz401_Depth_master 
group by catalog_id);

# Report mean and standard deviation read depth per locus
select avg(depth) from zz402_Depth_per_locus;
select stddev_samp(depth) from zz402_Depth_per_locus;

# Call a stored procedure that reports the mean and standard deviation of read depth per sample at
# each sequenced locus to a new table ("zz403_Depth_per_sample_per_locus")
call depth_per_sample();

# Report mean and standard deviation of read depth per locus per sample
select avg(mean), stddev_samp(mean) from zz403_Depth_per_sample_per_locus;

# Select read depth data for those loci that I want to order SNP assays for
create table zz405_Depth_per_sample_per_locus_120 (select t1.* from zz403_Depth_per_sample_per_locus as t1
inner join x6_Fluidigm_order as t2 on t1.cat_id = t2.namn);

# Create help table
create table zz404_Depth_master_120 (select t1.* from zz401_Depth_master as t1
inner join x6_Fluidigm_order as t2 on t1.catalog_id = t2.namn);

# Sum total read depth per locus for loci to order SNP assays for
create table zz406_Depth_per_locus_120 (select catalog_id, sum(depth) as depth from zz404_Depth_master_120 group by catalog_id);

# Inspect list of read depths
select * from zz406_Depth_per_locus_120;

# Report statistics on total read depth per locus (and locus/sample)
select avg(depth), stddev_samp(depth) from zz406_Depth_per_locus_120;
select avg(mean), stddev_samp(mean) from zz405_Depth_per_sample_per_locus_120;
