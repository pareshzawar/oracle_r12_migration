#! /bin/bash

#Author:Paresh Zawar

#Version 2.0

#Last Update Date: 10 May 2018

#You have to give your credentials.

#Oracle SQL Report and Report .rdf files migration are kept in script just to get the #location

export MIG_DIR = /home/oracle #Change location as per your path.

export RUN_LOCATION = $MIG_DIR/run #Change location as per your path.

export PATCH_LOCATION = $MIG_DIR/patch #Change location as per your path.

source <APPL_BASE>/EBSapps.env run

echo $RUN_BASE | cut -d / -f4 > $RUN_LOCATION

echo $PATCH_BASE | cut -d / -f4 > $PATCH_LOCATION

export username="<apps_username>";

export password=<apps_password>;

export replace="";

export run=`cat $RUN_LOCATION`

export patch=`cat $PATCH_LOCATION`

export replace="";

export thin_line="------------------------------------------------------------------------";

export thick_line="===========================";

export hisfile='$MIG_DIR/migration_history.txt'

export d=`date`

export EMAILCC=<Enter CC email_address>

export migfile='$MIG_DIR/sr_migration_history.txt'

echo ${thick_line} > $migfile

printf "Migration Details of Instance\n" >>$migfile

echo ${thick_line} >> $migfile

printf "\n${thick_line}Use Ctr + Backspace to delete at any time in script${thick_line}\n "

function migrate_main

{

        echo ${thin_line}

        echo -e "Oracle Migration"

        printf "\n1.Oracle SQL Migration\n\n2.Oracle Report Migration\n\n3.Oracle Form Migration\n\n4.Oracle LDT Migration\n\n5.Oracle Workflow Migration\n\n6.Exit\n"

        echo -n "Select an option what you have to migrate: "

        read line;

        printf "\n$thin_line\n";

        case "$line" in

        "1")migrate_sql

        ;;

        "2")migrate_report

        ;;

        "3")migrate_form

        ;;

        "4")migrate_ldt

        ;;

        "5")migrate_workflow

        ;;

        "6")goodbye

        ;;

        *)printf "\nPlease Enter valid option: "

        migrate_main

        ;;

esac

#printf "Your Choice is  $line \n";

#printf  "\nThank You !\n";

}

function migrate_again

{

        echo ${thin_line}

        echo -e "Do you want to migrate more files on the same ticket, If yes please select below option"

        printf "\n1.Oracle SQL Migration\n\n2.Oracle Report Migration\n\n3.Oracle Form Migration\n\4.Oracle LDT Migration\n\n5.Oracle Workflow Migration\n\n6.Migration completed, EXIT NOW\n\n"

        echo -n "Select an option what you have to migrate: "

        read line;

        printf "\n$thin_line\n";

        case "$line" in

        "1")sql_info

        ;;

        "2")rdf_info

        ;;

        "3")form_info

        ;;

        "4")ldt_info

        ;;

        "5")workflow_info

        ;;

        "6")mailgoodbye

        ;;

        *)mailgoodbye

        migrate_main

        ;;

esac

#printf "Your Choice is  $line \n";

#printf  "\nThank You !\n";

}

function confirm

{

        #echo ${thin_line};

        printf "\n===Are you sure that file is  uploaded at location?===\n1.Yes\n2.No\n3.Exit\n4.Back to main menu\nEnter your choice : "

        read ans;

        case "$ans" in

        "1") decision

        ;;

        "2")confirm

        ;;

        "3")goodbye

        ;;

        "4")migrate_main

        ;;

        esac

}

function decision

{

        printf "\n${thick_line}${thick_line}${thick_line}" >>$hisfile

        printf "\n\nPlease Enter Ticket Number: "

        read srno;

        printf "\nMigration History of Ticket Number $srno" >>$hisfile

        printf "\nStarted on $d " >>$hisfile

        case "$line" in

        "1")sql_info

        ;;

        "2")rdf_info

        ;;

        "3")form_info

        ;;

        "4")ldt_info

        ;;

        "5")workflow_info

        ;;

        esac

}

function goodbye

{

        printf "\nThank You !\nHave a nice day!\n"

        echo ${thin_line};

        exit 0

}

function mailgoodbye

{

        printf "\nChoose developer name from below list \n\n1.ABC \n2.DEF\n3.GHI\n4.JKL\n5.MNO\n6.PQR\n7.STU\n8.VWX\n9.YZ\n10.Don't send mail to anyone.\nFor other users enter email_address:\n"

        read devname;

        case "$devname" in

        "1")devemail=<RESPECTIVE_DEV_EMAIL_ADDRESS>

        ;;

        "2")devemail=<RESPECTIVE_DEV_EMAIL_ADDRESS>

        ;;

        "3")devemail=<RESPECTIVE_DEV_EMAIL_ADDRESS>

        ;;

        "4")devemail=<RESPECTIVE_DEV_EMAIL_ADDRESS>

        ;;

        "5")devemail=<RESPECTIVE_DEV_EMAIL_ADDRESS>

        ;;

        "6")devemail=<RESPECTIVE_DEV_EMAIL_ADDRESS>

        ;;

        "7")devemail=<RESPECTIVE_DEV_EMAIL_ADDRESS>

        ;;

        "8")devemail=<RESPECTIVE_DEV_EMAIL_ADDRESS>

        ;;

        "9")devemail=<RESPECTIVE_DEV_EMAIL_ADDRESS>

        ;;

        "10")goodbye

        ;;

        "*")devemail=devname

        ;;

        esac

        printf "\nTicket Number $srno is migrated by $devemail" >>$hisfile

        printf "\nSending details of migration in mail"

        export message_body=`cat $migfile`

        echo -e "Dear Developer,\n\nYour ticket  $srno has been migrated on production on $d \n\nThe Details of the migration is as below : \n$message_body\n\nRegards,\nXYZ\nCorporate IT\n "| mutt -s "Migration Summary of Ticket $srno on Production Instance"  -c $EMAILCC  -- $devemail

        printf "\nThank You !\nMail has been sent.\nHave a nice day!\n"

        echo ${thin_line};

        exit 0

}

function migrate_sql

{

        printf "Upload the file at $XX_TOP/sql\nEnsure file is uploaded in binary format !\n"

        echo ${thin_line};

        confirm;

}

function sql_info

{

        printf "Ensure file is present at $XX_TOP/sql\nEnter SQL report name(with/without .sql extension): "

        read sql_name;

        sql_name=${sql_name//.*/$replace}

        echo $sql_name;

        printf "\nCopying SQL report to patch file system\n."

        printf "\n $sql_name SQL Report has been migrated to both RUN file system as well as PATCH file system" >>$hisfile

        printf "\n $sql_name SQL Report has been migrated to both RUN file system as well as PATCH file system" >>$migfile

        cp $XX_TOP/sql/$sql_name.sql $PATCH_BASE/EBSapps/appl/XX/12.0.0/sql/$sql_name.sql

        printf "\ncp $XX_TOP/sql/$sql_name.sql $PATCH_BASE/EBSapps/appl/XX/12.0.0/sql/$sql_name.sql" >>$hisfile

        echo ${thin_line};

        cp $XX_TOP/sql/$sql_name.sql $MIG_DIR/reports/$sql_name.sql

        echo "Migration done successfully ! ";

        migrate_again

}

function migrate_report

{

        printf "Upload the file at $XX_TOP/reports/US\nEnsure file is uploaded in binary format !\n"

        echo ${thin_line};

        confirm;
 

}

function rdf_info

{

        printf "Ensure file present at $XX_TOP/reports/US\nEnter RDF report name(with/without .rdf extension): "

        read rdf_name;

        rdf_name=${rdf_name//.*/$replace}

        echo $rdf_name;

        printf "\nCopying RDF report to patch file system\n."

        cp $XX_TOP/reports/US/$rdf_name.rdf $PATCH_BASE/EBSapps/appl/XX/12.0.0/reports/US/$rdf_name.rdf

        cp $XX_TOP/reports/US/$rdf_name.rdf $MIG_DIR/reports/$rdf_name.rdf

        echo ${thin_line};

        printf "\n$rdf_name XX Report has been copied to both RUN file system, Patch file system and at backup location" >>$hisfile

        printf "\n$rdf_name XX Report has been copied to both RUN file system, Patch file system and at backup location" >>$migfile

        printf "\ncp $XX_TOP/reports/US/$rdf_name.rdf $PATCH_BASE/EBSapps/appl/XX/12.0.0/reports/US/$rdf_name.rdf" >>$hisfile

        echo "XX Report Migration done successfully ! ";

        migrate_again

}

function migrate_form

{

        printf "Upload the file at $AU_TOP/forms/US/\nEnsure file is uploaded in binary format !\n"

        echo ${thin_line};

        confirm;
 

}

function form_info

{

        printf "\nEnsure file present at $AU_TOP/forms/US/\nEnter form name: "

        read form_name;

        form_name=${form_name//.*/$replace}

        form_loc=$AU_TOP/forms/US/

        form_comp_loc=$XX_TOP/forms/US/

        printf "\nIf you choose different location than default, dependent object present at other location will not be compiled..\nEnsure that form is present at location"

        printf "\nEnter form location(Default $form_loc): "

        read temp_form_loc

        #len= echo $temp_form_loc | wc -c

        if [[ ! -z  "$temp_form_loc" ]]

        then

                form_loc=$temp_form_loc

                form_comp_loc=$temp_form_loc

        fi

        cd $form_loc

        pwd

        printf "\nCompiling $form_name.fmbto $form_name.fmx....."

        frmcmp_batch $from_loc$form_name.fmb Userid=$username/$password output_file=$form_comp_loc$form_name.fmx 2> mierr.txt

        echo ${thin_line};

        cp $AU_TOP/forms/US/$form_name.fmb  $PATCH_BASE/EBSapps/appl/au/12.0.0/forms/US/$form_name.fmb

        cp $XX_TOP/forms/US/$form_name.fmx  $PATCH_BASE/EBSapps/appl/XX/12.0.0/forms/US/$form_name.fmx

        cp $AU_TOP/forms/US/$form_name.fmb $MIG_DIR/forms/$form_name.fmb

        cp $XX_TOP/forms/US/$form_name.fmx $MIG_DIR/forms/$form_name.fmx

        printf "\n$form_name form has been uploaded and compiled on both RUN and Patch file system as well as at backup location" >>$hisfile

        printf "\n$form_name form has been uploaded and compiled on both RUN and Patch file system as well as at backup location" >>$migfile

        printf "\nfrmcmp_batch $from_loc$form_name.fmb Userid=$username/******** output_file=$form_comp_loc$form_name.fmx" >>$hisfile

        printf "\ncp $AU_TOP/forms/US/$form_name.fmb  $PATCH_BASE/EBSapps/appl/au/12.0.0/forms/US/$form_name.fmb" >>$hisfile

        printf "\ncp $XX_TOP/forms/US/$form_name.fmx  $PATCH_BASE/EBSapps/appl/XX/12.0.0/forms/US/$form_name.fmx" >>$hisfile

        echo "Copied fmb and fmx files to patch file system, Migration done successfully ! ";

        migrate_again

}

function migrate_ldt

{

        echo {$thin_line}

        printf "\nUpload the file at $MIG_DIR\nEnsure file is uploaded in binary format !\n"

        confirm;

}

function ldt_info

{

         echo "Enter LDT name: "

        read ldt_name;

        ldt_name=${ldt_name//.*/$replace}

        echo $ldt_name;

        #printf "\nPlease select LDT type\n1.Lookup\n2.Concurrent Program\n3.Profile\n4.Personalization\n5.Valueset\n6.Message\n";

        #printf "7.Request Group\n8.Request Set\n9.Menu\n10.Responsibility\n11.Alerts\n";

        #printf "\nEnter your choice: "

        #read ldt_choice;

        ldt_loc="$MIG_DIR";

        printf "\nIf you choose different location than default, dependent object present at other location will not be compiled..\nEnsure LDT is present at location"

        printf "\nEnter location of LDT(Default $ldt_loc): "

        read temp_ldt_loc

        if [[ ! -z "$temp_ldt_loc" ]]

        then

                ldt_loc=$temp_ldt_loc

        fi

        cd $ldt_loc;

        pwd;

        ldt_choice=$(cat $ldt_name.ldt | grep -i upload | cut -d@ -f2 | cut -d / -f4 | cut -d. -f1);

        #printf"\n$ldt_choice"

        #rm -f ldt_migration.txt ldt_error.txt

        printf "\nUploading $ldt_name.ldt to production....."

        case "$ldt_choice" in

        "aflvmlu")printf "\nUploading Lookup"

         $FND_TOP/bin/FNDLOAD $username/$password 0 Y UPLOAD $FND_TOP/patch/115/import/aflvmlu.lct $ldt_name.ldt UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE 1>ldt_migration.txt 2>ldt_error.txt

        echo ${thin_line}

        printf "\nMigrating Lookup $ldt_name.ldt \n$FND_TOP/bin/FNDLOAD $username/******* 0 Y UPLOAD $FND_TOP/patch/115/import/aflvmlu.lct $ldt_name.ldt UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE" >>$hisfile

        ;;

        "afcpprog")printf "\nUploading Concurrent Program"

        $FND_TOP/bin/FNDLOAD $username/$password 0 Y UPLOAD $FND_TOP/patch/115/import/afcpprog.lct $ldt_name.ldt - WARNING=YES UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE 1>ldt_migration.txt 2>ldt_error.txt

        echo ${thin_line}

        printf "\nMigrating Concurrent Program  $ldt_name.ldt\n $FND_TOP/bin/FNDLOAD $username/******* 0 Y UPLOAD $FND_TOP/patch/115/import/afcpprog.lct $ldt_name.ldt - WARNING=YES UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE" >>$hisfile

        ;;

        "afscprof")printf "\nUploading Profile"

        $FND_TOP/bin/FNDLOAD $username/$password 0 Y UPLOAD $FND_TOP/patch/115/import/afscprof.lct $ldt_name.ldt - WARNING=YES UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE 1> ldt_migration.txt 2> ldt_error.txt

             echo ${thin_line}

        printf "\nMigrating Profile $ldt_name.ldt \n $FND_TOP/bin/FNDLOAD $username/******* 0 Y UPLOAD $FND_TOP/patch/115/import/afscprof.lct $ldt_name.ldt - WARNING=YES UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE">>$hisfile

        ;;

        "affrmcus")printf "\nUploading Personalization"

        $FND_TOP/bin/FNDLOAD $username/$password 0 Y UPLOAD $FND_TOP/patch/115/import/affrmcus.lct $ldt_name.ldt 1> ldt_migration.txt 2> ldt_error.txt

        echo ${thin_line}

        printf "\nMigrating Personalization $ldt_name.ldt \n $FND_TOP/bin/FNDLOAD $username/******* 0 Y UPLOAD $FND_TOP/patch/115/import/affrmcus.lct $ldt_name.ldt" >>$hisfile

         ;;

        "afffload")printf "\nUploading ValueSet"

        $FND_TOP/bin/FNDLOAD $username/$password 0 Y UPLOAD $FND_TOP/patch/115/import/afffload.lct $ldt_name.ldt - WARNING=YES UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE 1> ldt_migration.txt 2> ldt_error.txt

        echo ${thin_line}

        printf "\nMigrating ValueSet $ldt_name.ldt\n$FND_TOP/bin/FNDLOAD $username/******* 0 Y UPLOAD $FND_TOP/patch/115/import/afffload.lct $ldt_name.ldt - WARNING=YES UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE" >>$hisfile

         ;;

        "afmdmsg")printf "\nUplodaing Message"

        $FND_TOP/bin/FNDLOAD $username/$password 0 Y UPLOAD $FND_TOP/patch/115/import/afmdmsg.lct $ldt_name.ldt UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE 1> ldt_migration.txt 2> ldt_error.txt

        echo ${thin_line}

        printf "\nMigrating Message $ldt_name.ldt\n$FND_TOP/bin/FNDLOAD $username/******* 0 Y UPLOAD $FND_TOP/patch/115/import/afmdmsg.lct $ldt_name.ldt UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE" >>$hisfile

        ;;

        "afcpreqg")printf "\nUplodaing Request Group"

        $FND_TOP/bin/FNDLOAD $username/$password 0 Y UPLOAD $FND_TOP/patch/115/import/afcpreqg.lct $ldt_name.ldt 1> ldt_migration.txt 2> ldt_error.txt

        echo ${thin_line}

        printf "\nMigrating Request Group $ldt_name.ldt\n$FND_TOP/bin/FNDLOAD $username/******* 0 Y UPLOAD $FND_TOP/patch/115/import/afcpreqg.lct $ldt_name.ldt" >>$hisfile

        ;;

        "afcprset")printf "\nUplodaing Request Set"

        $FND_TOP/bin/FNDLOAD $username/$password 0 Y UPLOAD $FND_TOP/patch/115/import/afcprset.lct $ldt_name.ldt 1> ldt_migration.txt 2> ldt_error.txt

        echo ${thin_line}

        printf "\nMigrating Request Set $ldt_name.ldt\n$FND_TOP/bin/FNDLOAD $username/******* 0 Y UPLOAD $FND_TOP/patch/115/import/afcprset.lct $ldt_name.ldt" >>$hisfile

         ;;

        "afsload")printf "\nUplodaing Menu/Form Function/D2K Form"

        $FND_TOP/bin/FNDLOAD $username/$password 0 Y UPLOAD $FND_TOP/patch/115/import/afsload.lct $ldt_name.ldt 1> ldt_migration.txt 2> ldt_error.txt

        echo ${thin_line}

        printf "\nMigrating Menu/Form Function/D2K Form $ldt_name.ldt\n$FND_TOP/bin/FNDLOAD $username/******* 0 Y UPLOAD $FND_TOP/patch/115/import/afsload.lct $ldt_name.ldt" >>$hisfile

        ;;

        "afscursp")printf "\nUplodaing Responsibility"

        $FND_TOP/bin/FNDLOAD $username/$password 0 Y UPLOAD $FND_TOP/patch/115/import/afscursp.lct $ldt_name.ldt  1> ldt_migration.txt 2> ldt_error.txt

         echo ${thin_line}

        printf "\nMigrating Responsibility $ldt_name.ldt\n$FND_TOP/bin/FNDLOAD $username/******* 0 Y UPLOAD $FND_TOP/patch/115/import/afscursp.lct $ldt_name.ldt" >>$hisfile

        ;;

        "alr")printf "\nUplodaing Alert"

        $FND_TOP/bin/FNDLOAD $username/$password 0 Y UPLOAD $ALR_TOP/patch/115/import/alr.lct $ldt_name.ldt CUSTOM_MODE=FORCE 1> ldt_migration.txt 2> ldt_error.txt

        echo ${thin_line}

        printf "\nMigrating Alert $ldt_name.ldt\n $FND_TOP/bin/FNDLOAD $username/******* 0 Y UPLOAD $ALR_TOP/patch/115/import/alr.lct $ldt_name.ldt CUSTOM_MODE=FORCE" >>$hisfile

         ;;

        esac

        echo ${thin_line}

        chmod 775 ldt_error.txt

        chmod 775 ldt_migration.txt

        lnc=$(cat ldt_migration.ldt | wc -l)

        export var=$(cat ldt_error.txt | grep -i Log | cut -d ":" -f2);

        if [[  -z "$lnc" ]]; then

                cat $var;

                echo "Migration in error !";

                migrate_again

        else

                cat $var;

                printf "\n$ldt_name LDT has been migrated successfully at $ldt_loc" >>$hisfile

                printf "\n$ldt_name LDT has been migrated successfully at $ldt_loc" >>$migfile

                cat ldt_migration.txt >>$hisfile

                cat ldt_migration.txt >>$migfile

                echo "Migration done successfully ! "

                migrate_again

        fi

}

function migrate_workflow

{

        echo {$thin_line}

        printf "\nUpload the file at $MIG_DIR\nEnsure file is uploaded in binary format !\n"

        confirm;

}

function workflow_info

{

        printf "Ensure file is present at $MIG_DIR \nEnter Workflow name: "

        read wf_name;

        wf_name=${wf_name//.*/$replace}

        echo $wf_name;

        printf "\nUploading $wf_name.wft to production....."

        loc="$MIG_DIR"

        cd $loc

        pwd

        WFLOAD $username/$password 0 Y FORCE $wf_name.wft

        echo ${thin_line};

        printf "\n$wf_name Workflow has been migrated successfully at $loc " >>$hisfile

        printf "\n$wf_name Workflow has been migrated successfully at $loc " >>$migfile

        printf "\WFLOAD $username/********** 0 Y FORCE $wf_name.wft" >>$hisfile

        echo "Migration done successfully ! ";

        printf "\nSometime there is need to bounce the Workflow for changes to take effect...\n"

        migrate_again

}

migrate_main
 