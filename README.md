# oracle_r12_migration
Automated Oracle Forms, LDT, Workflow Migration for R12.1 and R12.2

Version 1 (Oracle EBS R12.1.X)
This is the script for automatic migration of Oracle Forms, Workflow, LDT version 1 for Oracle eBS R12.1.X

Version 2(Oracle EBS R12.2.X)
We have introduced the version 2.0 of our existing script for automatic migration. In v2.0 we have introduce new history feature and mail feature. We have also address migration problem in Dual File System of R12.2.X by making exact copy of reports, forms (both fmx and fmb) to PATCH file system after the migration from RUN file system and also keeping backup copy of these reports and fmx and fmb to location other than Dual File System. This script is created for the DBA and can help in saving 10-15 minutes of DBA during each migration. Below is the generalize of migration shell script you can edit as per your requirement (knowledge of shell script required).

Originally posted on:
https://pareshzawar.wixsite.com/tech
