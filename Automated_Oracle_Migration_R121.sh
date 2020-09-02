#! /bin/bash

#Author:Paresh Zawar

#Version 1.0

#This script is created for automating the oracle forms,ldt,workflow,migration

#This is developer version,for repetitive migration.

#Please make changes as per your requirements

#You have to give your credentials.

#Oracle SQL Report and Report .rdf files migration are kept in script just to get the #location

export username="<your username>";

export password="<your password>";

export replace="";

export thin_line="------------------------------------------------------------------------";

export thick_line="===========================";


export ldt_loc="<your ldt location>";

printf "\n${thick_line}Use Ctr + Backspace to delete at any time in script${thick_line}\n "

#Load Application Environment

 . $APPL_TOP/<Environment File>.env

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

    case "$line" in

    "1")printf "\nMigration done successfully\n"

    ;;

    "2")printf "\nMigration done successfully\n"

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

function migrate_sql

{

    printf "Upload the file at $XXCUS_TOP/sql\nEnsure file is uploaded in binary format !\n"

    echo ${thin_line};

    confirm;

}

function migrate_report

{

    printf "Upload the file at $XXCUS_TOP/reports/US\nEnsure file is uploaded in binary format !\n"

    echo ${thin_line};

    confirm;

}

function migrate_form

{

    printf "\nUpload the file at $AU_TOP/forms/US\nEnsure file is uploaded in binary format !\n"

    echo ${thin_line};

    confirm;

}

function form_info

{

    echo "Enter form name: "

    read form_name;

    form_name=${form_name//.*/$replace}

    form_loc=$AU_TOP/forms/US/

    form_comp_loc=$XXCUS_TOP/forms/US/

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

    form_fmx;

}

function form_fmx

{

    printf "\nCompiling $form_name.fmbto $form_name.fmx....."

    frmcmp_batch $from_loc$form_name.fmb Userid=$username/$password output_file=$form_comp_loc$form_name.fmx 2> mierr.txt

    echo ${thin_line};

       echo "Migration done successfully ! ";

    printf "\n===Do you want to compile form again\n1.Yes\n2.No\n3.Exit\n4.Back to main menu\nEnter your choice : "

        read ans1;

        case "$ans1" in

        "1")form_fmx

        ;;

        "2")goodbye

        ;;

     "3")goodbye

        ;;

        "4")migrate_main

        ;;

        esac


}    
 

function migrate_ldt

{

    echo {$thin_line}

    printf "\nUpload the file at $ldt_loc\nEnsure file is uploaded in binary format !\n"

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

               printf "\nIf you choose different location than default, dependent object present at other location will not be compiled..\nEnsure LDT is present at location"

        printf "\nEnter location of LDT(Default $ldt_loc): "

        read temp_ldt_loc

        if [[ ! -z "$temp_ldt_loc" ]]

        then

                ldt_loc=$temp_ldt_loc

        fi

        cd $ldt_loc;

        pwd;

      ldt_mig;
 

}

 function ldt_mig

{

        ldt_choice=$(cat $ldt_name.ldt | grep -i upload | cut -d@ -f2 | cut -d / -f4 | cut -d. -f1);

        #printf"\n$ldt_choice"

        #rm -f ldt_migration.txt ldt_error.txt

        printf "\nUploading $ldt_name.ldt to production....."

        case "$ldt_choice" in

        "aflvmlu")printf "\nUploading Lookup"

         $FND_TOP/bin/FNDLOAD $username/$password 0 Y UPLOAD $FND_TOP/patch/115/import/aflvmlu.lct $ldt_name.ldt UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE 1>ldt_migration.txt 2>ldt_error.txt

        echo ${thin_line}

        ;;

        "afcpprog")printf "\nUploading Concurrent Program"

        $FND_TOP/bin/FNDLOAD $username/$password 0 Y UPLOAD $FND_TOP/patch/115/import/afcpprog.lct $ldt_name.ldt - WARNING=YES UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE 1>ldt_migration.txt 2>ldt_error.txt

        echo ${thin_line}

        ;;

        "afscprof")printf "\nUploading Profile"

        $FND_TOP/bin/FNDLOAD $username/$password 0 Y UPLOAD $FND_TOP/patch/115/import/afscprof.lct $ldt_name.ldt - WARNING=YES UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE 1> ldt_migration.txt 2> ldt_error.txt

         echo ${thin_line}

        ;;

        "affrmcus")printf "\nUploading Personalization"

        $FND_TOP/bin/FNDLOAD $username/$password 0 Y UPLOAD $FND_TOP/patch/115/import/affrmcus.lct $ldt_name.ldt 1> ldt_migration.txt 2> ldt_error.txt

        echo ${thin_line};;

        "afffload")printf "\nUploading ValueSet"

        $FND_TOP/bin/FNDLOAD $username/$password 0 Y UPLOAD $FND_TOP/patch/115/import/afffload.lct /appl/atulorc/$ldt_name.ldt - WARNING=YES UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE 1> ldt_migration.txt 2> ldt_error.txt

        echo ${thin_line} ;;

        "afmdmsg")printf "\nUplodaing Message"

        $FND_TOP/bin/FNDLOAD $username/$password 0 Y UPLOAD $FND_TOP/patch/115/import/afmdmsg.lct $ldt_name.ldt UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE 1> ldt_migration.txt 2> ldt_error.txt

        echo ${thin_line} ;;

        "afcpreqg")printf "\nUplodaing Request Group"

        $FND_TOP/bin/FNDLOAD $username/$password 0 Y UPLOAD $FND_TOP/patch/115/import/afcpreqg.lct $ldt_name.ldt 1> ldt_migration.txt 2> ldt_error.txt

        echo ${thin_line};;

        "afcprset")printf "\nUplodaing Request Set"

        $FND_TOP/bin/FNDLOAD $username/$password 0 Y UPLOAD $FND_TOP/patch/115/import/afcprset.lct /appl/atulorc/$ldt_name.ldt 1> ldt_migration.txt 2> ldt_error.txt

        echo ${thin_line} ;;

        "afsload")printf "\nUplodaing Menu/Form Function/D2K Form"

        $FND_TOP/bin/FNDLOAD $username/$password 0 Y UPLOAD $FND_TOP/patch/115/import/afsload.lct $ldt_name.ldt 1> ldt_migration.txt 2> ldt_error.txt

        echo ${thin_line}

        ;;

        "afscursp")printf "\nUplodaing Responsibility"

        $FND_TOP/bin/FNDLOAD $username/$password 0 Y UPLOAD $FND_TOP/patch/115/import/afscursp.lct $ldt_name.ldt  1> ldt_migration.txt 2> ldt_error.txt

         echo ${thin_line} ;;

        "alr")printf "\nUplodaing Alert"

        $FND_TOP/bin/FNDLOAD $username/$password 0 Y UPLOAD $ALR_TOP/patch/115/import/alr.lct $ldt_name.ldt CUSTOM_MODE=FORCE 1> ldt_migration.txt 2> ldt_error.txt

        echo ${thin_line} ;;

        esac

    echo ${thin_line}

        chmod 775 ldt_error.txt

        chmod 775 ldt_migration.txt

        lnc=$(cat ldt_migration.ldt | wc -l)

        export var=$(cat ldt_error.txt | grep -i Log | cut -d ":" -f2);

        if [[  -z "$lnc" ]]; then

                cat $var;

                echo "Migration in error !";

        else

                cat $var;

                echo "Migration done successfully ! "

        fi

        printf "\n===Do you want to compile ldt again\n1.Yes\n2.No\n3.Exit\n4.Back to main menu\nEnter your choice : "

        read ans2;

        case "$ans2" in

        "1")ldt_mig

        ;;

        "2")goodbye

        ;;

         "3")goodbye

        ;;

        "4")migrate_main

        ;;

        esac


}           

function migrate_workflow

{

    echo {$thin_line}

    printf "\nUpload the file at $APPL_TOP\nEnsure file is uploaded in binary format !\n"

    confirm;

}

function workflow_info

{

    echo "Enter Workflow name: "

    read wf_name;

    wf_name=${wf_name//.*/$replace}

    echo $wf_name;

    printf "\nUploading $wf_name.wft to production....."

    loc="/appl/atulorc/apps/apps_st/appl"

    cd $loc

    pwd

    com_wf;

}

function com_wf

{

    WFLOAD $username/$password 0 Y FORCE $wf_name.wft

     printf "\n===Do you want to compile form again\n1.Yes\n2.No\n3.Exit\n4.Back to main menu\nEnter your choice : "

        read ans1;

        case "$ans1" in

        "1")$command_wf

        ;;

        "2")goodbye

        ;;

         "3")goodbye

        ;;

        "4")migrate_main

        ;;

        esac

    echo ${thin_line};

       echo "Migration done successfully ! ";

    printf "\nSometime there is need to bounce the Workflow for changes to take effect...\n"

    printf "\n===Do you want to compile workflow again\n1.Yes\n2.No\n3.Exit\n4.Back to main menu\nEnter your choice : "

        read ans2;

        case "$ans2" in

        "1")com_wf

        ;;

        "2")goodbye

        ;;

         "3")goodbye

        ;;

        "4")migrate_main

        ;;

        esac

}

migrate_main
